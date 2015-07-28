//
//  JSTGradientView.m
//  SmoothGradient
//
//  Created by Jernej Strasner on 11/3/13.
//  Copyright (c) 2013 Jernej Strasner. All rights reserved.
//

#import "JSTGradientView.h"

#define SyntesizeRedrawableProperty(setter, ivar, type) \
- (void)setter:(type)value { \
    if (ivar == value) return; \
    ivar = value; \
    [self setNeedsDisplay]; \
}

@implementation JSTGradientView

- (instancetype)init
{
    self = [super init];
    [self setup];
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    [self setup];
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    [self setup];
    return self;
}

- (void)setup
{
    self.contentMode = UIViewContentModeRedraw;
}

SyntesizeRedrawableProperty(setSmooth, _smooth, BOOL)
SyntesizeRedrawableProperty(setReverse, _reverse, BOOL)
SyntesizeRedrawableProperty(setStartColor, _startColor, UIColor *)

- (void)drawRect:(CGRect)rect
{
    // Draw the gradient background
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();

    // Get color components
    CGColorRef color = _startColor.CGColor;
    const CGFloat *startColorComponents = CGColorGetComponents(color);
    CGFloat *colorComponents = calloc(8, sizeof(CGFloat));
    memset(colorComponents, 1, 8*sizeof(CGFloat)); // Set to white by default
    memcpy(colorComponents, startColorComponents, CGColorGetNumberOfComponents(color)*sizeof(CGFloat)); // Copy first color
    memcpy(colorComponents+4, startColorComponents, CGColorGetNumberOfComponents(color)*sizeof(CGFloat)); // Copy second color
    colorComponents[3] = _reverse ? 1.0f : 0.0f; // Alpha value for the start color
    colorComponents[7] = _reverse ? 0.0f : 1.0f; // Alpha value for the end color

    if (_smooth) {
        // Define the shading callbacks
        CGFunctionCallbacks callbacks = {0, shadingFunction, NULL};

        // As input to our function we want 1 value in the range [0.0, 1.0].
        // This is our position within the 'gradient'.
        size_t domainDimension = 1;
        CGFloat domain[2] = {0.0f, 1.0f};

        // The output of our function is 2 values, each in the range [0.0, 1.0].
        // This is our selected color for the input position.
        // The 2 values are the white and alpha components.
        size_t rangeDimension = 4;
        CGFloat range[8] = {
            0.0f, 1.0f,
            0.0f, 1.0f,
            0.0f, 1.0f,
            0.0f, 1.0f
        };

        // Create the shading finction
        CGFunctionRef function = CGFunctionCreate(colorComponents, domainDimension, domain, rangeDimension, range, &callbacks);

        // Create the shading object
        CGShadingRef shading = CGShadingCreateAxial(colorSpace, CGPointMake(1, rect.size.height), CGPointMake(1, 0), function, YES, YES);

        // Draw the shading
        CGContextDrawShading(context, shading);

        // Clean up
        CGFunctionRelease(function);
        CGShadingRelease(shading);
    }
    else {
        // Color locations
        CGFloat locations[2] = {0.0f, 1.0f};

        // The gradient
        CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, colorComponents, locations, 2);

        // Draw the gradient
        CGContextDrawLinearGradient(context, gradient, CGPointMake(1, rect.size.height), CGPointMake(1, 0), kCGGradientDrawsAfterEndLocation | kCGGradientDrawsBeforeStartLocation);

        // Clean up
        CGGradientRelease(gradient);
    }

    // Clean up
    CGColorSpaceRelease(colorSpace);
    free(colorComponents);
}

// This is the callback of our shading function.
// info:    not needed
// inData:  contains a single float that gives is the current position within the gradient
// outData: we fill this with the color to display at the given position
static void shadingFunction(void *info, const CGFloat *inData, CGFloat *outData)
{
    CGFloat *color = info; // Pointer to the components of the 2 colors we're interpolating (only using one color for now)
    float p = inData[0]; // Position in gradient
    outData[0] = color[0];
    outData[1] = color[1];
    outData[2] = color[2];
    outData[3] = fabs(color[3]-slope(p, 2.0f)); // Alpha channel interpolation
}

// Distributes values on a slope aka. ease-in ease-out
static float slope(float x, float A) {
    float p = powf(x, A);
    return p/(p + powf(1.0f-x, A));
}

@end
