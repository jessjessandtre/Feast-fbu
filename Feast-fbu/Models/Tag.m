//
//  Tag.m
//  Feast-fbu
//
//  Created by Jessica Au on 7/31/18.
//  Copyright © 2018 jessjessandtre. All rights reserved.
//

#import "Tag.h"
#import "Recipe.h"

@implementation Tag

@dynamic recipe, name;

+ (nonnull NSString *)parseClassName {
    return @"Tag";
}

+ (void)createTag:(NSString*)tagName forRecipe:(Recipe*)recipe withCompletion:(void(^)(Boolean succeeded))completion
{
    PFObject *tagActivity = [PFObject objectWithClassName:@"Tag"];
    [tagActivity setObject:tagName forKey:@"name"];
    [tagActivity setObject:recipe forKey:@"recipe"];
    [tagActivity saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            NSLog(@"added tag");
            completion(true);
        }
        else {
            NSLog(@"error adding tag %@", error.localizedDescription);
            completion(false);
        }
    }];
}

+ (void)tagExists:(NSString*)tagName forRecipe:(Recipe*)recipe withCompletion:(void(^)(Boolean exists))completion {
    PFQuery* query = [PFQuery queryWithClassName:@"Tag"];
    [query whereKey:@"name" equalTo:tagName];
    [query whereKey:@"recipe" equalTo:recipe];
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
            NSLog(@"error counting tags: %@", error.localizedDescription);
            completion(false);
        }
    }];
}



@end
