//
//  TYProgressIndeterminateProgressBar.h
//  IQ
//
//  Created by Tejaswi Y on 2/29/12.
//  See copyright notice attached. Basically, use it however you want. If you can link back to my repo on github, that'd be cool.

#import <UIKit/UIKit.h>

@interface TYIndeterminateProgressBar : UIView
{

}

#if __has_feature(objc_arc)
@property (strong) UIColor *bgColor;
@property (strong) UIColor *indicatorColor;
@property (strong) UIColor *borderColor;
#else
@property (retain) UIColor *bgColor;
@property (retain) UIColor *indicatorColor;
@property (retain) UIColor *borderColor;
#endif

// Initializes with a standard white background & blue spinner.
+ (void) showInView:(UIView *) view;

// If you'd like to customize the defaults, provide a color for the background and indicator
+ (void) showInView:(UIView *)view 
    backgroundColor:(UIColor *) bgColor 
     indicatorColor:(UIColor *) indicatorColor 
        borderColor:(UIColor *) borderColor;

// Removes the view from a given view if present.
+ (void) hideFromView:(UIView *) view;
@end
