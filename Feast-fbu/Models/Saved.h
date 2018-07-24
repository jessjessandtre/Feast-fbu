//
//  Saved.h
//  Feast-fbu
//
//  Created by Jessica Shu on 7/23/18.
//  Copyright © 2018 jessjessandtre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "Recipe.h"

@interface Saved : PFObject <PFSubclassing>

@property (strong, nonatomic) PFUser* user;
@property (strong, nonatomic) Recipe* savedRecipe;

@end
