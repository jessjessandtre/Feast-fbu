//
//  Like.h
//  Feast-fbu
//
//  Created by Jessica Au on 7/24/18.
//  Copyright © 2018 jessjessandtre. All rights reserved.
//

#import "PFObject.h"
#import <Parse/Parse.h>
#import "Post.h"

@interface Like : PFObject

@property (strong, nonatomic) PFUser *fromUser;
@property (strong, nonatomic) PFUser *toUser;
@property (strong, nonatomic) Post *post;

+ (void)userLikesPost:(Post*)post withCompletion:(void(^)(Boolean liked))completion;
+ (void)unlikePost:(Post*)post withCompletion:(void(^)(Boolean succeeded))completion;
+ (void)likePost:(Post*)post withCompletion:(void(^)(Boolean succeeded))completion;
+ (void)numberOfLikesForPost:(Post*)post withCompletion:(void(^)(int likes))completion;

@end
