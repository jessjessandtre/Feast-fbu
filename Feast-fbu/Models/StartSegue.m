//
//  StartSegue.m
//  Feast-fbu
//
//  Created by Jessica Shu on 8/9/18.
//  Copyright © 2018 jessjessandtre. All rights reserved.
//

#import "StartSegue.h"

@implementation StartSegue

- (void)perform {
    [self scale];
}

- (void)scale {
    UIViewController* fromViewController = [self sourceViewController];
    UIViewController* toViewController = [self destinationViewController];
    
    UIView* containerView = fromViewController.view.superview;
    CGPoint originalCenter = fromViewController.view.center;
    
    toViewController.view.transform = CGAffineTransformMakeScale(0.05, 0.05);
    toViewController.view.center = originalCenter;
    
    [containerView addSubview:toViewController.view];
    
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        toViewController.view.transform = CGAffineTransformIdentity;
        
        
    } completion:^(BOOL finished) {
        if (finished){
            [fromViewController presentViewController:toViewController animated:false completion:nil];
        }
    }];
}


@end
