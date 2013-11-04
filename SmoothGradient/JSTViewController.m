//
//  JSTViewController.m
//  SmoothGradient
//
//  Created by Jernej Strasner on 11/3/13.
//  Copyright (c) 2013 Jernej Strasner. All rights reserved.
//

#import "JSTViewController.h"
#import "JSTGradientView.h"

@interface JSTViewController ()

@end

@implementation JSTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)switchMode:(UISegmentedControl *)sender
{
	[(JSTGradientView *)self.view redrawSmooth:sender.selectedSegmentIndex];
}

@end
