//
//  Like.m
//  Feast-fbu
//
//  Created by Jessica Au on 7/24/18.
//  Copyright © 2018 jessjessandtre. All rights reserved.
//

#import "Like.h"

@implementation Like

@dynamic fromUser, toUser, post; 

+ (void)userLikesPost:(Post*)post withCompletion:(void(^)(Boolean liked))completion {
    PFQuery* query = [PFQuery queryWithClassName:@"Like"];
    [query whereKey:@"fromUser" equalTo:[PFUser currentUser]];
    [query whereKey:@"post" equalTo:post];
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
            NSLog(@"error counting number of likes: %@", error.localizedDescription);
            completion(false);
        }
    }];
}

+ (void)unlikePost:(Post*)post withCompletion:(void(^)(Boolean succeeded))completion {
    PFQuery* query = [PFQuery queryWithClassName:@"Like"];
    [query whereKey:@"fromUser" equalTo:[PFUser currentUser]];
    [query whereKey:@"post" equalTo:post];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (!error){
            Like* like = (Like*)objects[0];
            [like deleteInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                if (succeeded){
                    NSLog(@"unliked object");
                    completion(true);
                }
                else {
                    NSLog(@"error unliking object: %@", error.localizedDescription);
                    completion(false);
                }
            }];
        }
        else {
            NSLog(@"error retreiving like object: %@", error.localizedDescription);
            completion(false);
        }
    }];
}


+ (void)likePost:(Post*)post withCompletion:(void(^)(Boolean succeeded))completion {
    PFObject *likeActivity = [PFObject objectWithClassName:@"Like"];
    [likeActivity setObject:[PFUser currentUser] forKey:@"fromUser"];
    [likeActivity setObject:post.user forKey:@"toUser"];
    [likeActivity setObject:post forKey:@"post"];
    [likeActivity saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded){
            completion(true);
        }
        else {
            NSLog(@"error liking post: %@", error.localizedDescription);
            completion(false);
        }
    }];
}

+ (void)numberOfLikesForPost:(Post*)post withCompletion:(void(^)(int likes))completion {
    PFQuery* query = [PFQuery queryWithClassName:@"Like"];
    [query whereKey:@"post" equalTo:post];
    [query countObjectsInBackgroundWithBlock:^(int number, NSError * _Nullable error) {
        if (!error){
            completion(number);
        }
        else {
            NSLog(@"error counting number of likes: %@", error.localizedDescription);
            completion(-1);
        }
    }];
}

@end
