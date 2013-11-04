//
//  JSTGradientView.m
//  SmoothGradient
//
//  Created by Jernej Strasner on 11/3/13.
//  Copyright (c) 2013 Jernej Strasner. All rights reserved.
//

#import "JSTGradientView.h"

@implementation JSTGradientView {
	BOOL _smooth;
}

- (void)redrawSmooth:(BOOL)smooth
{
	_smooth = smooth;
	[self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    
}

@end
