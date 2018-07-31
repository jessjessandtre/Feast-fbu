//
//  DetailRecipeTableViewCell.m
//  Feast-fbu
//
//  Created by Jessica Au on 7/27/18.
//  Copyright © 2018 jessjessandtre. All rights reserved.
//

#import "DetailRecipeTableViewCell.h"
#import <ParseUI/ParseUI.h>
#import <Parse/Parse.h>
#import "Saved.h"

@implementation DetailRecipeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setRecipe {
    self.recipeImageView.file = self.recipe.image;
    [self.recipeImageView loadInBackground];
    
    self.recipeTitleLabel.text = self.recipe.name;
    
    NSString *ingredientsString = @"";
    for (int i = 0; i < self.recipe.ingredients.count; i++) {
        ingredientsString = [ingredientsString stringByAppendingString:[NSString stringWithFormat:@" - %@\n", self.recipe.ingredients[i]] ];
    }
    self.ingredientsLabel.text = ingredientsString;
    
    self.instructionsLabel.text = self.recipe.instructions;
    self.sourceURLLabel.text = self.recipe.sourceURL;
    
    [self updateSaveButton];
}

- (void)updateSaveButton {
    [Saved savedRecipeExists:self.recipe withCompletion:^(Boolean saved) {
        if (saved){
            [self.saveButton setSelected:YES];
        } else {
            [self.saveButton setSelected:NO];
        }
    }];
}


@end
