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
	// Draw the gradient background
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
	
	if (_smooth) {
		// Define the shading callbacks
		CGFunctionCallbacks callbacks = {0, blackShade, NULL};
		
		// As input to our function we want 1 value in the range [0.0, 1.0].
		// This is our position within the 'gradient'.
		size_t domainDimension = 1;
		CGFloat domain[2] = {0.0f, 1.0f};
		
		// The output of our function is 2 values, each in the range [0.0, 1.0].
		// This is our selected color for the input position.
		// The 2 values are the white and alpha components.
		size_t rangeDimension = 2;
		CGFloat range[8] = {0.0f, 1.0f, 0.0f, 1.0f};
		
		// Create the shading finction
		CGFunctionRef function = CGFunctionCreate(NULL, domainDimension, domain, rangeDimension, range, &callbacks);
		
		// Create the shading object
		CGShadingRef shading = CGShadingCreateAxial(colorSpace, CGPointMake(1, rect.size.height), CGPointMake(1, rect.size.height*0.75f), function, YES, YES);
		
		// Draw the shading
		CGContextDrawShading(context, shading);
		
		// Clean up
		CGFunctionRelease(function);
		CGShadingRelease(shading);
	}
	else {
		// Color components
		CGFloat colorComponents[4] = {
			0.0f, 0.5f,
			0.0f, 0.0f
		};
		
		// Color locations
		CGFloat locations[2] = {
			0.0f,
			1.0f
		};
		
		// The gradient
		CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, colorComponents, locations, 2);
		
		// Draw the gradient
		CGContextDrawLinearGradient(context, gradient, CGPointMake(1, rect.size.height), CGPointMake(1, rect.size.height*0.75f), kCGGradientDrawsAfterEndLocation | kCGGradientDrawsBeforeStartLocation);
		
		// Clean up
		CGGradientRelease(gradient);
	}
	
	// Clean up
	CGColorSpaceRelease(colorSpace);
}

// This is the callback of our shading function.
// info:    not needed
// inData:  contains a single float that gives is the current position within the gradient
// outData: we fill this with the color to display at the given position
static void blackShade(void *info, const CGFloat *inData, CGFloat *outData)
{
	float p = inData[0];
	outData[0] = 0.0f;
	outData[1] = (1.0f-slope(p, 2.0f)) * 0.5f;
}

// Distributes values on a slope aka. ease-in ease-out
static float slope(float x, float A) {
	float p = powf(x, A);
	return p/(p + powf(1.0f-x, A));
}

@end
