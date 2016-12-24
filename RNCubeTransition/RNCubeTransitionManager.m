//
//  RNCubeTransitionManager.m
//  RNCubeTransition
//
//  Created by Thomas Lackemann on 12/21/16.
//  Copyright © 2016 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RNCubeTransitionManager.h"
#import "RNCubeTransition.h"

@implementation RNCubeTransitionManager

RCT_EXPORT_MODULE()

- (UIView *)view {
    return [[RNCubeTransition alloc] init];
}

@end
