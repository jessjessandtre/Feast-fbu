//
//  Recipe.h
//  Feast-fbu
//
//  Created by Jessica Shu on 7/19/18.
//  Copyright © 2018 jessjessandtre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface Recipe : PFObject <PFSubclassing>
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) PFFile *image;
@property (nonatomic, strong) NSArray *ingredients;
@property (nonatomic, strong) NSString *instructions;
@property (nonatomic, strong) NSNumber *numPosts;
@property (nonatomic, strong) NSString *sourceURL;
@property (nonatomic, strong) NSMutableArray *tags;

@end
