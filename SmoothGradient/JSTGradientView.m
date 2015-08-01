// The MIT License (MIT)
//
// Copyright (c) 2014 Jernej Strasner
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of
// this software and associated documentation files (the "Software"), to deal in
// the Software without restriction, including without limitation the rights to
// use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
// the Software, and to permit persons to whom the Software is furnished to do so,
// subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
// FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
// COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
// IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
// CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import "JSTGradientView.h"

@implementation JSTGradientView {
    CGColorSpaceRef colorSpace;
    CGFloat startColorComps[4];
    CGFloat endColorComps[4];
}

- (instancetype)init
{
    return [self initWithFrame:CGRectZero];
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
    self.startColor = [UIColor whiteColor];
    self.endColor = [UIColor blackColor];
    self.startPoint = CGPointMake(0.5, 0);
    self.endPoint = CGPointMake(1.5, 1);
}

- (void)dealloc
{
    CGColorSpaceRelease(colorSpace);
}

- (void)setInterpolationFactor:(CGFloat)interpolationFactor
{
    if (_interpolationFactor == interpolationFactor) return;
    _interpolationFactor = interpolationFactor;
    [self setNeedsDisplay];
}

- (void)setStartColor:(UIColor *)startColor
{
    if (_startColor == startColor) return;
    _startColor = startColor;

    [startColor getRed:startColorComps green:startColorComps+1 blue:startColorComps+2 alpha:startColorComps+3];

    [self setNeedsDisplay];
}

- (void)setEndColor:(UIColor *)endColor
{
    if (_endColor == endColor) return;
    _endColor = endColor;

    [endColor getRed:endColorComps green:endColorComps+1 blue:endColorComps+2 alpha:endColorComps+3];

    [self setNeedsDisplay];
}

- (void)setDrawsBeforeStart:(BOOL)drawsBeforeStart
{
    if (_drawsBeforeStart == drawsBeforeStart) return;
    _drawsBeforeStart = drawsBeforeStart;
    [self setNeedsDisplay];
}

- (void)setDrawsAfterEnd:(BOOL)drawsAfterEnd
{
    if (_drawsAfterEnd == drawsAfterEnd) return;
    _drawsAfterEnd = drawsAfterEnd;
    [self setNeedsDisplay];
}

- (void)setStartPoint:(CGPoint)startPoint
{
    if (CGPointEqualToPoint(_startPoint, startPoint)) return;
    _startPoint = startPoint;
    [self setNeedsDisplay];
}

- (void)setEndPoint:(CGPoint)endPoint
{
    if (CGPointEqualToPoint(_endPoint, endPoint)) return;
    _endPoint = endPoint;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    // Prepare general variables
    CGContextRef context = UIGraphicsGetCurrentContext();

    // Shading function info
    JSTFunctionInfo functionInfo;
    memcpy(functionInfo.startColor, startColorComps, sizeof(CGFloat)*4);
    memcpy(functionInfo.endColor, endColorComps, sizeof(CGFloat)*4);
    functionInfo.slopeFactor = self.interpolationFactor;

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
    CGFunctionRef function = CGFunctionCreate(&functionInfo, domainDimension, domain, rangeDimension, range, &callbacks);

    // Create the shading object
    CGPoint startPoint = CGPointMake(self.startPoint.x * rect.size.width, self.startPoint.y * rect.size.height);
    CGPoint endPoint = CGPointMake(self.endPoint.x * rect.size.width, self.endPoint.y * rect.size.height);
    CGShadingRef shading = CGShadingCreateAxial(colorSpace, startPoint, endPoint, function, self.drawsBeforeStart, self.drawsAfterEnd);

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
static void shadingFunction(void *infoPtr, const CGFloat *inData, CGFloat *outData)
{
    JSTFunctionInfo info = *(JSTFunctionInfo*)infoPtr; // Info struct with colors and parameters
    float p = inData[0]; // Position in gradient
    float q = slope(p, info.slopeFactor); // Slope value
    outData[0] = info.startColor[0] + (info.endColor[0] - info.startColor[0])*q;
    outData[1] = info.startColor[1] + (info.endColor[1] - info.startColor[1])*q;
    outData[2] = info.startColor[2] + (info.endColor[2] - info.startColor[2])*q;
    outData[3] = info.startColor[3] + (info.endColor[3] - info.startColor[3])*q;
}

// Distributes values on a slope aka. ease-in ease-out
static float slope(float x, float A)
{
    float p = powf(x, A);
    return p/(p + powf(1.0f-x, A));
}

// Info struct to pass to shading function
struct _JSTFunctionInfo {
    CGFloat startColor[4];
    CGFloat endColor[4];
    CGFloat slopeFactor;
};
typedef struct _JSTFunctionInfo JSTFunctionInfo;

@end
