//
//  Tag.h
//  Feast-fbu
//
//  Created by Jessica Au on 7/31/18.
//  Copyright © 2018 jessjessandtre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "Recipe.h"

@interface Tag : PFObject <PFSubclassing>

@property (strong, nonatomic) Recipe *recipe;
@property (strong, nonatomic) NSString *name;

@end
