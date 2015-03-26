//
//  WebViewController.m
//  NPPHomework4
//
//  Created by Nick Peters on 3/5/15.
//  Copyright (c) 2015 Nick Peters. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController () <UIGestureRecognizerDelegate> {
    CGFloat _centerX;
}

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.name;
    
    [self.webView loadRequest:self.request];
    
    UIScreenEdgePanGestureRecognizer *leftEdgeGesture = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(handleLeftEdgeGesture:)];
    leftEdgeGesture.edges = UIRectEdgeLeft;
    leftEdgeGesture.delegate = self;
    [self.view addGestureRecognizer:leftEdgeGesture];
    
    // Store the center, so we can animate back to it after a slide
    _centerX = self.view.bounds.size.width / 2;
}

- (void)handleLeftEdgeGesture:(UIScreenEdgePanGestureRecognizer *)gesture {
    // Get the current view we are touching
    UIView *view = [self.view hitTest:[gesture locationInView:gesture.view] withEvent:nil];
    
    if(UIGestureRecognizerStateBegan == gesture.state ||
       UIGestureRecognizerStateChanged == gesture.state) {
        CGPoint translation = [gesture translationInView:gesture.view];
        // Move the view's center using the gesture
        view.center = CGPointMake(_centerX + translation.x, view.center.y);
    } else {// cancel, fail, or ended
        // Animate back to center x
        [UIView animateWithDuration:.3 animations:^{
            
            view.center = CGPointMake(_centerX, view.center.y);
        }];
    }
}

@end
