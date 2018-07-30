//
//  Follow.h
//  Feast-fbu
//
//  Created by Jessica Au on 7/23/18.
//  Copyright © 2018 jessjessandtre. All rights reserved.
//

#import "PFObject.h"

@interface Follow : PFObject

@property (strong, nonatomic) PFUser* fromUser;
@property (strong, nonatomic) PFUser* toUser; 

+ (void)userIsFollowing:(PFUser*)user fromUser:(PFUser*)fromUser withCompletion:(void(^)(Boolean followed))completion;
+ (void)unFollowUser:(PFUser*)toUser fromUser:(PFUser*)fromUser withCompletion:(void(^)(Boolean succeeded))completion;
+ (void)followUser:(PFUser*)user fromUser:(PFUser*)fromUser withCompletion:(void(^)(Boolean succeeded))completion;
+ (void)numberOfFollowers:(PFUser*)user withCompletion:(void(^)(int followers))completion;
+ (void)numberOfFollowing:(PFUser*)user withCompletion:(void(^)(int following))completion;

@end
