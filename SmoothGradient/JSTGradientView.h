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

#import <UIKit/UIKit.h>

@interface JSTGradientView : UIView

/// The starting color of the gradient.
@property (nonatomic, retain, nonnull) IBInspectable UIColor *startColor;

/// End ending color of the gradient.
@property (nonatomic, retain, nonnull) IBInspectable UIColor *endColor;

/// The interpolation factor of the gradient. This defines how smooth the color transition is.
@property (nonatomic, assign) IBInspectable CGFloat interpolationFactor;

/// If YES the gradient is drawn before the start point.
@property (nonatomic, assign) IBInspectable BOOL drawsBeforeStart;

/// If YES the gradient is drawn past the end point.
@property (nonatomic, assign) IBInspectable BOOL drawsAfterEnd;

/// The location of the gradient drawing start relative to the view's coordinate space (0.0 - 1.0).
@property (nonatomic, assign) IBInspectable CGPoint startPoint;

/// The location of the gradient drawing end relative to the view's coordinate space (0.0 - 1.0).
@property (nonatomic, assign) IBInspectable CGPoint endPoint;

@end
