//
//  FollowViewController.h
//  Feast-fbu
//
//  Created by Jessica Au on 8/8/18.
//  Copyright © 2018 jessjessandtre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface FollowViewController : UIViewController

@property PFUser *user;
@property NSString *followOrFollowing;

@end
