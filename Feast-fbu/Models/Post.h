//
//  Post.h
//  Feast-fbu
//
//  Created by Jessica Shu on 7/19/18.
//  Copyright © 2018 jessjessandtre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "Recipe.h"

@interface Post : PFObject <PFSubclassing>

@property (strong, nonatomic) PFUser* user;
@property (strong, nonatomic) Recipe* recipe;
@property (strong, nonatomic) NSString* caption;
@property (strong, nonatomic) PFFile *image;
@property (strong, nonatomic) NSNumber *numberLikes;
@property (strong, nonatomic) NSNumber *numberComments;

+ (void)updateLikesForPost:(Post*)post;

@end
