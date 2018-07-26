//
//  Saved.m
//  Feast-fbu
//
//  Created by Jessica Shu on 7/23/18.
//  Copyright © 2018 jessjessandtre. All rights reserved.
//

#import "Saved.h"

@implementation Saved

@dynamic user, savedRecipe;

+ (nonnull NSString *)parseClassName {
    return @"Saved";
}

+ (void)savedRecipeExists:(Recipe*)recipe withCompletion:(void(^)(Boolean saved))completion { 
    PFQuery* saveQuery = [PFQuery queryWithClassName:@"Saved"];
    [saveQuery whereKey:@"user" equalTo:[PFUser currentUser]];
    [saveQuery whereKey:@"savedRecipe" equalTo:recipe];
    [saveQuery countObjectsInBackgroundWithBlock:^(int number, NSError * _Nullable error) {
        if (!error){
            if (number >= 1){
                completion(true);
            }
            else {
                completion(false);
            }
        }
        else {
            NSLog(@"error counting number of saved recipes: %@", error.localizedDescription);
        }
    }];
}

+ (void)deleteSavedRecipe:(Recipe*)recipe withCompletion:(void(^)(Boolean succeeded))completion {
    PFQuery* query = [PFQuery queryWithClassName:@"Saved"];
    [query whereKey:@"user" equalTo:[PFUser currentUser]];
    [query whereKey:@"savedRecipe" equalTo:recipe];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (!error){
            Saved* saved = (Saved*)objects[0];
            [saved deleteInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                if (succeeded){
                    NSLog(@"deleted saved object");
                    completion(true);
                }
                else {
                    NSLog(@"error deleting save object: %@", error.localizedDescription);
                    completion(false);
                }
            }];
        }
        else {
            NSLog(@"error retreiving saved object: %@", error.localizedDescription);
            completion(false);
        }
    }];
}

+ (void)saveRecipe:(Recipe*)recipe withCompletion:(void(^)(Boolean succeeded))completion {
    Saved* saved = [Saved new];
    [saved setObject:[PFUser currentUser] forKey:@"user"];
    [saved setObject:recipe forKey:@"savedRecipe"];
    [saved saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded){
            NSLog(@"saved recipe");
            completion(true);
        }
        else {
            NSLog(@"error saving recipe: %@", error.localizedDescription);
            completion(false);
        }
    }];
}


@end
