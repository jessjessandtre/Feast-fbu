//
//  Post.m
//  Feast-fbu
//
//  Created by Jessica Shu on 7/19/18.
//  Copyright © 2018 jessjessandtre. All rights reserved.
//

#import "Post.h"
#import <Parse/Parse.h>

@implementation Post

@dynamic user, recipe, image, caption, numberLikes, numberComments;
+ (nonnull NSString *)parseClassName {
    return @"Post";
}

@end
