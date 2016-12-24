//
//  RNCubeTransition.m
//  RNCubeTransition
//
//  Created by Thomas Lackemann on 12/21/16.
//  Copyright © 2016 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RNCubeTransition.h"

@interface RNCubeTransition()
@property (nonatomic, assign) CGPoint initialCenter;
@property (nonatomic, assign) int currentIndex;
@property (nonatomic, assign) int nextIndex;
@property (nonatomic, assign) long numberOfFaces;
@property (nonatomic, assign) bool initialized;
@property (nonatomic, assign) bool snap;
@property (nonatomic, assign) bool panning;
@property (nonatomic, strong) UIView *nextSubview;
@property (nonatomic, strong) UIView *nextScreenshot;
@property (nonatomic, strong) CATransition *animation;
@property (nonatomic, strong) NSTimer *timer;


@end

@implementation RNCubeTransition

- (instancetype)init {
    if ((self = [super init])) {
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        [pan setMinimumNumberOfTouches:1];
        [pan setMaximumNumberOfTouches:1];
        [self addGestureRecognizer:pan];
        self.initialized = false;
        self.currentIndex = 0;
        self.nextIndex = 0;
        self.snap = false;
    }
    return self;
}

- (void)layoutSubviews {
    if (!self.initialized) {
        self.numberOfFaces = [self.subviews count];
        self.initialized = true;
    }
}

// Handle the pan gesture to rotate the cube
- (void)handlePan:(UIPanGestureRecognizer *)pan {
    
    // Get the current view
    UIView *_currentSubview = [self.subviews objectAtIndex:self.currentIndex];
    
    // How far we've moved
    CGPoint translation = [pan translationInView:self];
    
    // Capture velocity for flick gesture
    CGPoint velocity = [pan velocityInView:pan.view];
    double percentageOfWidthIncludingVelocity = (translation.x + 0.25 * velocity.x) / self.frame.size.width;
    
    // Moving left
    if (translation.x < 0) {
        self.nextIndex = 0;
        
        // Get the next subview in line
        if (self.currentIndex + 1 < self.numberOfFaces) {
            self.nextIndex = self.currentIndex + 1;
        }
        
        if (pan.state == UIGestureRecognizerStateBegan) {
            // Take a screenshot of the next face on first gesture
            self.nextSubview = [self.subviews objectAtIndex:self.nextIndex];
            self.nextScreenshot = [self.nextSubview snapshotViewAfterScreenUpdates:NO];
            
            // Start the animation
            [CATransaction begin];
            [self addSubview:self.nextScreenshot];
            self.animation = [CATransition animation];
            self.animation.duration = 1.0;
            [self.animation setType:@"cube"];
            [self.animation setSubtype:kCATransitionFromRight];
            //      [self.animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
            
            self.layer.speed = 0.0;
            [[self layer] addAnimation:self.animation forKey:@"cube"];
            [CATransaction commit];
            
            self.panning = true;
        }
        
        // pan the cube
        if (self.panning) {
            self.layer.timeOffset = fabs(translation.x) / self.frame.size.width;
        }
        
        // Once we stop the gesture, fulfill the animation
        // Check to make sure we were panning though because sometimes we fail to take a screenshot
        // and that makes it look bad
        if (pan.state == UIGestureRecognizerStateEnded && self.panning) {
            // Continue with the animation
            
            [self.layer removeAllAnimations];
            [self.nextScreenshot removeFromSuperview];
            
            self.layer.speed = 1.0;
            
            [CATransaction begin];
            self.animation = [CATransition animation];
            self.animation.duration = 1.0;
            
            // If we're past a certain time, just move forward
            if (self.layer.timeOffset >= 0.5) {
                self.snap = YES;
                self.animation.speed = -0.75;
                self.animation.beginTime = CACurrentMediaTime() + ((self.layer.timeOffset - 1.0) * 1.25);
            } else {
                self.animation.speed = 0.75;
                self.animation.beginTime = CACurrentMediaTime() - ((1.0 - self.layer.timeOffset) * 1.25);
            }
            
            self.animation.fillMode = kCAFillModeForwards;
            self.animation.removedOnCompletion = NO; // prevents image from flickering
            [self.animation setType:@"cube"];
            [self.animation setSubtype:kCATransitionFromLeft];
            
            [CATransaction setCompletionBlock:^{
                [self.layer removeAllAnimations];
                
                [self.nextScreenshot removeFromSuperview];
                
                if (self.snap == YES) {
                    // Move the next image/view into place
                    CGRect currentSubviewOffsetFrame = [[_currentSubview.layer presentationLayer] frame];
                    currentSubviewOffsetFrame.origin.x = -1 * _currentSubview.bounds.size.width * (self.currentIndex + 1);
                    _currentSubview.frame = currentSubviewOffsetFrame;
                    
                    CGRect nextSubviewOffsetFrame = [[self.nextSubview.layer presentationLayer] frame];
                    nextSubviewOffsetFrame.origin.x = 0;
                    self.nextSubview.frame = nextSubviewOffsetFrame;
                    
                    self.currentIndex = self.nextIndex;
                }
                self.snap = NO;
            }];
            
            [[self layer] addAnimation:self.animation forKey:@"cube"];
            [CATransaction commit];
            
            self.panning = false;
        }
    }
    // End Moving Left
    
    // Moving Right
    if (translation.x >= 0) {
        self.nextIndex = self.numberOfFaces - 1;
        
        // Get the next subview in line
        if (self.currentIndex - 1 >= 0) {
            self.nextIndex = self.currentIndex - 1;
        }
        
        if (pan.state == UIGestureRecognizerStateBegan) {
            // Take a screenshot of the next face on first gesture
            self.nextSubview = [self.subviews objectAtIndex:self.nextIndex];
            self.nextScreenshot = [self.nextSubview snapshotViewAfterScreenUpdates:NO];
            
            // Start the animation
            [CATransaction begin];
            [self addSubview:self.nextScreenshot];
            self.animation = [CATransition animation];
            self.animation.duration = 1.0;
            [self.animation setType:@"cube"];
            [self.animation setSubtype:kCATransitionFromLeft];
            //      [self.animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
            
            self.layer.speed = 0.0;
            [[self layer] addAnimation:self.animation forKey:@"cube"];
            [CATransaction commit];
            
            self.panning = true;
        }
        
        // pan the cube
        if (self.panning) {
            self.layer.timeOffset = fabs(translation.x) / self.frame.size.width;
        }
        
        // Once we stop the gesture, fulfill the animation
        // Check to make sure we were panning though because sometimes we fail to take a screenshot
        // and that makes it look bad
        if (pan.state == UIGestureRecognizerStateEnded && self.panning) {
            // Continue with the animation
            
            [self.layer removeAllAnimations];
            [self.nextScreenshot removeFromSuperview];
            
            self.layer.speed = 1.0;
            
            [CATransaction begin];
            self.animation = [CATransition animation];
            self.animation.duration = 1.0;
            
            // If we're past a certain time, just move forward
            if (self.layer.timeOffset >= 0.5) {
                self.snap = YES;
                self.animation.speed = -0.75;
                self.animation.beginTime = CACurrentMediaTime() + ((self.layer.timeOffset - 1.0) * 1.25);
            } else {
                self.animation.speed = 0.75;
                self.animation.beginTime = CACurrentMediaTime() - ((1.0 - self.layer.timeOffset) * 1.25);
            }
            
            self.animation.fillMode = kCAFillModeForwards;
            self.animation.removedOnCompletion = NO; // prevents image from flickering
            [self.animation setType:@"cube"];
            [self.animation setSubtype:kCATransitionFromRight];
            
            [CATransaction setCompletionBlock:^{
                [self.layer removeAllAnimations];
                
                [self.nextScreenshot removeFromSuperview];
                
                if (self.snap == YES) {
                    // Move the next image/view into place
                    CGRect currentSubviewOffsetFrame = [[_currentSubview.layer presentationLayer] frame];
                    currentSubviewOffsetFrame.origin.x = -1 * _currentSubview.bounds.size.width * (self.currentIndex + 1);
                    _currentSubview.frame = currentSubviewOffsetFrame;
                    
                    CGRect nextSubviewOffsetFrame = [[self.nextSubview.layer presentationLayer] frame];
                    nextSubviewOffsetFrame.origin.x = 0;
                    self.nextSubview.frame = nextSubviewOffsetFrame;
                    
                    self.currentIndex = self.nextIndex;
                }
                self.snap = NO;
            }];
            
            [[self layer] addAnimation:self.animation forKey:@"cube"];
            [CATransaction commit];
            
            self.panning = false;
        }
    }
    // End Moving Right
}
@end
