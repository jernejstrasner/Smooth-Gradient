# Smooth gradients on iOS using CGShading

This project includes the class `JSTGradientView` which is a `UIView` subclass that can be used wherever a smooth gradient is needed.
This is a replacement for manually drawing a gradient using `CGGradient`. The class used `CGShading` internally instead.
To see why, look at the two images below:

![Smooth](http://jernejstrasner.com/images/2013-10-17/gradient_ps.png) ![Regular](http://jernejstrasner.com/images/2013-10-17/gradient_cg.png)

The first one is drawn using `JSTGradientView` with an interpolation factor of 2, the second one is drawn using `CGGradient`.
Guess which one designers usually put in their designs? Yep, the first one. Most image editing software does a better job at interpolating colors than `CGGradient`
and to mimic that `JSTGradientView` was born.

Check out the code and sample app to see how the interpolation factor affects the gradient.

A full **Swift 2** version of the class is available in the branch [swift2](https://github.com/jernejstrasner/Smooth-Gradient/tree/swift2).

## Setup

### Carthage

Start by adding the following line to your [Cartfile](https://github.com/Carthage/Carthage/blob/master/Documentation/Artifacts.md#cartfile).
```ruby
github "jernejstrasner/Smooth-Gradient" ~> 1.0
```
The run
```sh
carthage update
```
and add the built frameworks to your Xcode project.

Full instructions on installing dependencies with Carthage can be found in [Carthage's README](https://github.com/Carthage/Carthage#adding-frameworks-to-an-application).
