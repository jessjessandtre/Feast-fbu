//
//  Comment.h
//  Feast-fbu
//
//  Created by Jessica Au on 7/24/18.
//  Copyright © 2018 jessjessandtre. All rights reserved.
//

#import "PFObject.h"
#import <Parse/Parse.h>
#import "Post.h"

@interface Comment : PFObject

@property (strong, nonatomic) PFUser *fromUser;
@property (strong, nonatomic) PFUser *toUser;
@property (strong, nonatomic) Post *post;
@property (strong, nonatomic) NSString *comment;

@end
