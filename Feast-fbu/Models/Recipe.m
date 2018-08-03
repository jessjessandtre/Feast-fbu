//
//  Recipe.m
//  Feast-fbu
//
//  Created by Jessica Shu on 7/19/18.
//  Copyright © 2018 jessjessandtre. All rights reserved.
//

#import "Recipe.h"

@implementation Recipe

@dynamic name, image, ingredients, instructions, numPosts, sourceURL, tags, courseType;

+ (nonnull NSString *)parseClassName {
    return @"Recipe";
}

@end
