//
//  TYViewController.m
//  TYProgressBarTest
//
//  Created by Tejaswi Y on 3/5/12.

#import "TYViewController.h"
#import "TYIndeterminateProgressBar.h"

@implementation TYViewController

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self showSpinner];
    [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(hideSpinner:) userInfo:nil repeats:NO];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
}

-(void) showSpinner {
    // When you want to show the progress bar:
    [TYIndeterminateProgressBar showInView:self.view];
    
    // You can also customize the spinnercolors by using this instead
    /* [TYIndeterminateProgressBar showInView:self.view backgroundColor:[UIColor whiteColor] indicatorColor:[UIColor greenColor] borderColor:[UIColor darkGrayColor]]; */
}

-(void) hideSpinner:(id) sender {
    [TYIndeterminateProgressBar hideFromView:self.view];
}

@end
