//
//  JSTViewController.m
//  SmoothGradient
//
//  Created by Jernej Strasner on 11/3/13.
//  Copyright (c) 2013 Jernej Strasner. All rights reserved.
//

#import "JSTViewController.h"
#import "JSTGradientView.h"

@implementation JSTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self reset];
}

- (IBAction)reset:(id)sender
{
    [self reset];
}

- (IBAction)reverse:(id)sender
{
    self.gradientView.reverse = !self.gradientView.reverse;
}

- (IBAction)slopeFactorChanged:(UISlider *)sender
{
    float factor = log(sender.value);
    printf("Factor: %f\n", factor);
    self.gradientView.slopeFactor = factor;
    [self updateLabel];
}

- (void)reset
{
    self.gradientView.reverse = NO;
    self.gradientView.slopeFactor = 2.0f;
    self.slider.value = pow(M_E, 2.0f);
    [self updateLabel];
}

- (void)updateLabel
{
    self.factorLabel.text = [NSString stringWithFormat:@"Slope factor: %0.4fx", self.gradientView.slopeFactor];
}

@end
