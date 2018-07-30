//
//  Follow.m
//  Feast-fbu
//
//  Created by Jessica Au on 7/23/18.
//  Copyright © 2018 jessjessandtre. All rights reserved.
//

#import "Follow.h"
#import <Parse/Parse.h>

@implementation Follow

@dynamic fromUser, toUser;

+ (nonnull NSString *)parseClassName {
    return @"Recipe";
}

+ (void)userIsFollowing:(PFUser*)user fromUser:(PFUser*)fromUser withCompletion:(void(^)(Boolean followed))completion {
    PFQuery *query = [PFQuery queryWithClassName:@"Follow"];
    [query whereKey:@"fromUser" equalTo:[PFUser currentUser]];
    [query whereKey:@"toUser" equalTo:user];
    [query countObjectsInBackgroundWithBlock:^(int number, NSError * _Nullable error) {
        if (!error){
            if (number >= 1){
                completion(true);
            }
            else {
                completion(false);
            }
        }
        else {
            NSLog(@"error counting number of following: %@", error.localizedDescription);
            completion(false);
        }

    }];
}

+ (void)unFollowUser:(PFUser*)toUser fromUser:(PFUser*)fromUser withCompletion:(void(^)(Boolean succeeded))completion {
    PFQuery *query = [PFQuery queryWithClassName:@"Follow"];
    [query whereKey:@"fromUser" equalTo:fromUser];
    [query whereKey:@"toUser" equalTo:toUser];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
        if (object) {
            [object deleteInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                if (succeeded){
                    NSLog(@"unfollowed user");
                    completion(true);
                }
                else {
                    NSLog(@"error unfollowing: %@", error.localizedDescription);
                    completion(false);
                }
            }];
        }
        else {
            NSLog(@"Unable to retrieve object: %@", error.localizedDescription);
            completion(false);
        }
    }];
}

+ (void)followUser:(PFUser*)user fromUser:(PFUser*)fromUser withCompletion:(void(^)(Boolean succeeded))completion {
    PFObject *followActivity = [PFObject objectWithClassName:@"Follow"];
    [followActivity setObject:fromUser forKey:@"fromUser"];
    [followActivity setObject:user forKey:@"toUser"];
    
    [followActivity saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded){
            NSLog(@"followed user");
            completion(true);
        }
        else {
            NSLog(@"error following user: %@", error.localizedDescription);
            completion(false);
        }
    }];
}

+ (void)numberOfFollowers:(PFUser*)user withCompletion:(void(^)(int followers))completion {
    PFQuery *query = [PFQuery queryWithClassName:@"Follow"];
    [query whereKey:@"toUser" equalTo:user];
    [query countObjectsInBackgroundWithBlock:^(int number, NSError * _Nullable error) {
        if (!error){
            completion(number);
        }
        else {
            NSLog(@"error counting number of followers: %@", error.localizedDescription);
            completion(-1);
        }
        
    }];
}

+ (void)numberOfFollowing:(PFUser*)user withCompletion:(void(^)(int following))completion {
    PFQuery *query = [PFQuery queryWithClassName:@"Follow"];
    [query whereKey:@"fromUser" equalTo:user];
    [query countObjectsInBackgroundWithBlock:^(int number, NSError * _Nullable error) {
        if (!error){
            completion(number);
        }
        else {
            NSLog(@"error counting number of following: %@", error.localizedDescription);
            completion(-1);
        }
        
    }];
}

@end
