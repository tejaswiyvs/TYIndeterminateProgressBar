//
//  TYProgressIndeterminateProgressBar.m
//  IQ
//
//  Created by Tejaswi Y on 2/29/12.
//  Use it however you want. If you can link back to my repo on github (https://tejaswiyvs@github.com/tejaswiyvs/TYIndeterminateProgressBar.git),
//  that'd be awesome.

#import "TYIndeterminateProgressBar.h"
#import <QuartzCore/QuartzCore.h>

@interface TYIndeterminateProgressBar (private)
-(void) setRoundedView:(UIView *)roundedView toDiameter:(float)newSize;
-(void) deviceOrientationDidChange:(NSNotification *)notification;
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
    NSLog(@"view rect = %@", NSStringFromCGRect(view.frame));
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
    progressBar.bgColor = bgColor;
    progressBar.indicatorColor = indicatorColor;
    progressBar.borderColor = borderColor;
    // Centers it in the current view's frame.
    [view addSubview:progressBar];
    [[NSNotificationCenter defaultCenter] addObserver:progressBar 
                                             selector:@selector(deviceOrientationDidChange:) 
												 name:UIDeviceOrientationDidChangeNotification 
                                               object:nil];
}

+ (void) hideFromView:(UIView *) view {
    for (UIView *subview in view.subviews) {
        if ([subview isKindOfClass:[self class]]) {
            // TODO: (origin.y - 10.0) won't work if someone tweaks the size / position settings.
            [UIView animateWithDuration:0.5 
                                  delay:0.0 
                                options:UIViewAnimationCurveEaseOut 
                             animations:^{
                                 subview.alpha = 0.0;
                             } 
                             completion:^(BOOL completed) {
                                 if(completed) {
                                     [subview removeFromSuperview];
                                 }
                             }];
        }
    }
}

#pragma mark - UIViewOverloads

- (void) removeFromSuperview {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIDeviceOrientationDidChangeNotification
                                                  object:nil];
    
    [super removeFromSuperview];
}

- (void) layoutSubviews {
    [super layoutSubviews];
    
    // Layout the holder
    float x = (self.superview.bounds.size.width - kProgressBarWidth) / 2;
    float y = self.superview.bounds.origin.y;
    CGRect endRect = CGRectMake(x, y, kProgressBarWidth, kProgressBarHeight);
    [self setFrame:endRect];
    [self.layer setCornerRadius:3.0];
    [self.layer setBorderColor:[self.borderColor CGColor]];
    [self.layer setBorderWidth:0.25];
    [self setBackgroundColor:self.bgColor];
    [self setAlpha:0.0];
    [UIView animateWithDuration:0.5 
                          delay:0.0 
                        options:UIViewAnimationCurveEaseOut 
                     animations:^{
                         self.alpha = 1.0;
                     } 
                     completion:^(BOOL completed) {
                         if(completed) {
                             [UIView animateWithDuration:1.0f
                                                   delay:0.0f
                                                 options: UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse | UIViewAnimationOptionBeginFromCurrentState
                                              animations: ^(void){
                                                  UIView *spinnerView = [self viewWithTag:kSpinnerTag];
                                                  float x = kProgressBarWidth - kSpinnerWidth;
                                                  spinnerView.frame = CGRectMake(x, spinnerView.frame.origin.y, kSpinnerWidth, kSpinnerHeight);
                                              }
                                              completion:nil];
                         }
                     }];    
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

#if !__has_feature(objc_arc)
- (void)dealloc {
    [_bgColor release];
    [_indicatorColor release];
    [_borderColor release];
    [super dealloc];
}
#endif

#pragma mark - Helpers

-(void)setRoundedView:(UIView *)roundedView toDiameter:(float)newSize;
{
    CGPoint saveCenter = roundedView.center;
    CGRect newFrame = CGRectMake(roundedView.frame.origin.x, roundedView.frame.origin.y, newSize, newSize);
    roundedView.frame = newFrame;
    roundedView.layer.cornerRadius = newSize / 2.0;
    roundedView.center = saveCenter;
}

-(void) deviceOrientationDidChange:(NSNotification *)notification {
	if (!self.superview) {
		return;
	}
    self.bounds = self.superview.bounds;
    [self setNeedsLayout];
}

@end
