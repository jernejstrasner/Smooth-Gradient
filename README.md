## Smooth gradients on iOS using CGShading

First, compare the two images below:

![Smooth](http://jernejstrasner.com/images/2013-10-17/gradient_ps.png) ![Regular](http://jernejstrasner.com/images/2013-10-17/gradient_cg.png)

The first one is drawn using the class published here (JSTGradientView) with a slope factor of 2, the second one is drawn using a linear CGGradient. Guess which one designers usually draw in Photoshop? Yep, the first one.

Check out the code and comments for more.
