//
//  ExternalProfileViewController.h
//  Feast-fbu
//
//  Created by Jessica Au on 7/23/18.
//  Copyright © 2018 jessjessandtre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "Post.h"

@interface ExternalProfileViewController : UIViewController

@property (strong, nonatomic) PFUser *user;

@end
