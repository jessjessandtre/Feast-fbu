//
//  Post.m
//  Feast-fbu
//
//  Created by Jessica Shu on 7/19/18.
//  Copyright © 2018 jessjessandtre. All rights reserved.
//

#import "Post.h"

@implementation Post

@dynamic user, image, caption;
+ (nonnull NSString *)parseClassName {
    return @"Post";
}
@end
