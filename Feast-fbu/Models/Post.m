//
//  Post.m
//  Feast-fbu
//
//  Created by Jessica Shu on 7/19/18.
//  Copyright © 2018 jessjessandtre. All rights reserved.
//

#import "Post.h"
#import <Parse/Parse.h>
#import "Like.h"

@implementation Post

@dynamic user, recipe, image, caption, numberLikes, numberComments;
+ (nonnull NSString *)parseClassName {
    return @"Post";
}

+ (void)updateLikes:(int)likes ForPost:(Post*)post {
    post.numberLikes = [NSNumber numberWithInt:likes];
    [post saveEventually];
}


@end
