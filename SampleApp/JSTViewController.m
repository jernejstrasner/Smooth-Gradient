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
    CGPoint startPoint = self.gradientView.startPoint;
    self.gradientView.startPoint = self.gradientView.endPoint;
    self.gradientView.endPoint = startPoint;
}

- (IBAction)slopeFactorChanged:(UISlider *)sender
{
    self.gradientView.interpolationFactor = log(sender.value);
    [self updateLabel];
}

- (void)reset
{
    self.gradientView.startPoint = CGPointMake(0.5, 0);
    self.gradientView.endPoint = CGPointMake(0.5, 1);
    self.gradientView.interpolationFactor = 2.0f;
    self.slider.value = pow(M_E, 2.0f);
    [self updateLabel];
}

- (void)updateLabel
{
    self.factorLabel.text = [NSString stringWithFormat:@"Slope factor: %0.4fx", self.gradientView.interpolationFactor];
}

@end
