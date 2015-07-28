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

@implementation JSTGradientView {
    CGColorSpaceRef colorSpace;
    CGFloat startColorComps[4];
    CGFloat endColorComps[4];
}

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
    colorSpace = CGColorSpaceCreateDeviceRGB();
}

- (void)dealloc
{
    CGColorSpaceRelease(colorSpace);
}

SyntesizeRedrawableProperty(setReverse, _reverse, BOOL)
SyntesizeRedrawableProperty(setSlopeFactor, _slopeFactor, CGFloat)

- (void)setStartColor:(UIColor *)startColor
{
    if (_startColor == startColor) return;
    _startColor = startColor;

    GetColorComponents(startColor.CGColor, startColorComps);
    [self setNeedsDisplay];
}

- (void)setEndColor:(UIColor *)endColor
{
    if (_endColor == endColor) return;
    _endColor = endColor;

    GetColorComponents(endColor.CGColor, endColorComps);
    [self setNeedsDisplay];
}

void GetColorComponents(CGColorRef color, CGFloat *outComponents) {
    size_t numberOfComponents = CGColorGetNumberOfComponents(color);
    if (numberOfComponents != 4) assert("Only RGBA colors supported!");
    const CGFloat *components = CGColorGetComponents(color);
    memcpy(outComponents, components, sizeof(CGFloat)*numberOfComponents);
}

- (void)drawRect:(CGRect)rect
{
    // Prepare general variables
    CGContextRef context = UIGraphicsGetCurrentContext();

    // Shading function info
    CGFloat functionInfo[9];
    // First color
    memcpy(functionInfo, (_reverse ? endColorComps : startColorComps), sizeof(CGFloat)*4);
    // Second color
    memcpy(functionInfo+4, (_reverse ? startColorComps : endColorComps), sizeof(CGFloat)*4);
    // Slope factor
    functionInfo[8] = _slopeFactor;

    // Define the shading callbacks
    CGFunctionCallbacks callbacks = {0, shadingFunction, NULL};

    // As input to our function we want 1 value in the range [0.0, 1.0].
    // This is our position within the gradient.
    size_t domainDimension = 1;
    CGFloat domain[2] = {0.0f, 1.0f};

    // The output of our shading function are 4 values, each in the range [0.0, 1.0].
    // By specifying 4 ranges here, we limit each color component to that range. Values outside of the range get clipped.
    size_t rangeDimension = 4;
    CGFloat range[8] = {
        0.0f, 1.0f, // R
        0.0f, 1.0f, // G
        0.0f, 1.0f, // B
        0.0f, 1.0f  // A
    };

    // Create the shading function
    CGFunctionRef function = CGFunctionCreate(functionInfo, domainDimension, domain, rangeDimension, range, &callbacks);

    // Create the shading object
    CGShadingRef shading = CGShadingCreateAxial(colorSpace, CGPointMake(1, rect.size.height), CGPointMake(1, 0), function, YES, YES);

    // Draw the shading
    CGContextDrawShading(context, shading);

    // Clean up
    CGFunctionRelease(function);
    CGShadingRelease(shading);
}

// This is the callback of our shading function.
// info:    color and slope information
// inData:  contains a single float that gives is the current position within the gradient
// outData: we fill this with the color to display at the given position
static void shadingFunction(void *info, const CGFloat *inData, CGFloat *outData)
{
    CGFloat *colors = info; // Pointer to the components of the 2 colors we're interpolating
    CGFloat slopeFactor = colors[8]; // Slope factor stored in the colors array
    float p = inData[0]; // Position in gradient
    float q = slope(p, slopeFactor); // Slope value
    outData[0] = colors[0] + (colors[4] - colors[0])*q;
    outData[1] = colors[1] + (colors[5] - colors[1])*q;
    outData[2] = colors[2] + (colors[6] - colors[2])*q;
    outData[3] = colors[3] + (colors[7] - colors[3])*q;
}

// Distributes values on a slope aka. ease-in ease-out
static float slope(float x, float A)
{
    float p = powf(x, A);
    return p/(p + powf(1.0f-x, A));
}

@end
