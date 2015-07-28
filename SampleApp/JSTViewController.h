//
//  JSTViewController.h
//  SmoothGradient
//
//  Created by Jernej Strasner on 11/3/13.
//  Copyright (c) 2013 Jernej Strasner. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JSTGradientView;

@interface JSTViewController : UIViewController

@property (weak, nonatomic) IBOutlet JSTGradientView *gradientView;
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet UILabel *factorLabel;

- (IBAction)reset:(id)sender;
- (IBAction)reverse:(id)sender;
- (IBAction)slopeFactorChanged:(UISlider *)sender;

@end
