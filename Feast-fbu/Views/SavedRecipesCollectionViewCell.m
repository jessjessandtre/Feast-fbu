//
//  SavedRecipesCollectionViewCell.m
//  Feast-fbu
//
//  Created by Jessica Shu on 7/25/18.
//  Copyright © 2018 jessjessandtre. All rights reserved.
//

#import "SavedRecipesCollectionViewCell.h"

@implementation SavedRecipesCollectionViewCell

- (void)setRecipe:(Recipe *)recipe {
    _recipe = recipe;
    
    self.recipeImageView.file = recipe.image;
    [self.recipeImageView loadInBackground];
}

@end
