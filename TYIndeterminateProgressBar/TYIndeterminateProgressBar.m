//
//  TYProgressIndeterminateProgressBar.m
//  IQ
//
//  Created by Tejaswi Y on 2/29/12.
//  Use it however you want. If you can link back to my repo on github, that'd be cool.

#import "TYIndeterminateProgressBar.h"
#import <QuartzCore/QuartzCore.h>

@interface TYIndeterminateProgressBar (private)
-(void) setRoundedView:(UIView *)roundedView toDiameter:(float)newSize;
@end

@implementation TYIndeterminateProgressBar

static float kProgressBarWidth = 75.0;
static float kProgressBarHeight = 5.0;
static float kSpinnerWidth = 5.0;
static float kSpinnerHeight = 5.0;
static int kSpinnerTag = 10;

@synthesize bgColor = _bgColor;
@synthesize indicatorColor = _indicatorColor;
@synthesize borderColor = _borderColor;

+ (void) showInView:(UIView *) view {
    UIColor *bgColor = [UIColor whiteColor];
    UIColor *indicatorColor = [UIColor blueColor];
    UIColor *borderColor = [UIColor darkGrayColor];
    [TYIndeterminateProgressBar showInView:view 
                           backgroundColor:bgColor 
                            indicatorColor:indicatorColor
                               borderColor:borderColor];
}

+ (void) showInView:(UIView *) view 
    backgroundColor:(UIColor *) bgColor 
     indicatorColor:(UIColor *) indicatorColor 
        borderColor:(UIColor *) borderColor {
    TYIndeterminateProgressBar *progressBar = [[TYIndeterminateProgressBar alloc] init];
#if !__has_feature(objc_arc)
    [progressBar autorelease];
#endif
    // Centers it in the current view's frame.
    float x = (view.frame.size.width - kProgressBarWidth) / 2;
    float y = 0.0;
    CGRect startFrame = CGRectMake(x, y - 10.0, kProgressBarWidth, kProgressBarHeight);
    CGRect endFrame = CGRectMake(x, y, kProgressBarWidth, kProgressBarHeight);
    [progressBar setFrame:startFrame];
    progressBar.bgColor = bgColor;
    progressBar.indicatorColor = indicatorColor;
    progressBar.borderColor = borderColor;
    [view addSubview:progressBar];
    [UIView animateWithDuration:0.5 
                          delay:0.0 
                        options:UIViewAnimationCurveEaseOut 
                     animations:^{
                         progressBar.frame = endFrame;
                     } 
                     completion:^(BOOL completed) {
                         if(completed) {
                             [UIView animateWithDuration:1.0f
                                                   delay:0.0f
                                                 options: UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse | UIViewAnimationOptionBeginFromCurrentState
                                              animations: ^(void){
                                                      UIView *spinnerView = [progressBar viewWithTag:kSpinnerTag];
                                                      float x = kProgressBarWidth - kSpinnerWidth;
                                                      spinnerView.frame = CGRectMake(x, spinnerView.frame.origin.y, kSpinnerWidth, kSpinnerHeight);
                                              }
                                              completion:nil];
                         }
                     }];
}

+ (void) hideFromView:(UIView *) view {
    for (UIView *subview in view.subviews) {
        if ([subview isKindOfClass:[self class]]) {
            // TODO: (origin.y - 10.0) won't work if someone tweaks the size / position settings.
            [UIView animateWithDuration:0.5 
                                  delay:0.0 
                                options:UIViewAnimationCurveEaseOut 
                             animations:^{
                                 CGRect newFrame = CGRectMake(subview.frame.origin.x, subview.frame.origin.y - 10.0, kProgressBarWidth, kProgressBarHeight);
                                 subview.frame = newFrame;
                             } 
                             completion:^(BOOL completed) {
                                 if(completed) {
                                     [subview removeFromSuperview];
                                 }
                             }];
        }
    }
}

- (void) layoutSubviews {
    [self.layer setCornerRadius:3.0];
    [self.layer setBorderColor:[self.borderColor CGColor]];
    [self.layer setBorderWidth:0.25];
    [self setBackgroundColor:self.bgColor];
    
    NSLog(@"%f, %f", self.frame.origin.x, self.frame.origin.y);
    UIView *spinnerView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, kSpinnerWidth, kSpinnerHeight)];
#if !__has_feature(objc_arc)
    [spinnerView autorelease];
#endif
    [spinnerView setBackgroundColor:self.indicatorColor];
    [self setRoundedView:spinnerView toDiameter:kSpinnerHeight];
    [self addSubview:spinnerView];
    spinnerView.tag = kSpinnerTag;
}

-(void)setRoundedView:(UIView *)roundedView toDiameter:(float)newSize;
{
    CGPoint saveCenter = roundedView.center;
    CGRect newFrame = CGRectMake(roundedView.frame.origin.x, roundedView.frame.origin.y, newSize, newSize);
    roundedView.frame = newFrame;
    roundedView.layer.cornerRadius = newSize / 2.0;
    roundedView.center = saveCenter;
}

@end
