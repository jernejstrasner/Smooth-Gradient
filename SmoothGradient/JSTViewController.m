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

- (IBAction)switchMode:(UISegmentedControl *)sender
{
	[(JSTGradientView *)self.view redrawSmooth:sender.selectedSegmentIndex];
}

@end
