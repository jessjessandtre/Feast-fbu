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


+ (void)savedRecipeExists:(Recipe*)recipe withCompletion:(void(^)(Boolean saved))completion;
+ (void)deleteSavedRecipe:(Recipe*)recipe withCompletion:(void(^)(Boolean succeeded))completion;
+ (void)saveRecipe:(Recipe*)recipe withCompletion:(void(^)(Boolean succeeded))completion;

@end
