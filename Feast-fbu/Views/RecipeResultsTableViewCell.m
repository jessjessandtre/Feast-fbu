//
//  RecipeResultsTableViewCell.m
//  Feast-fbu
//
//  Created by Jessica Shu on 8/3/18.
//  Copyright © 2018 jessjessandtre. All rights reserved.
//

#import "RecipeResultsTableViewCell.h"

@implementation RecipeResultsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setRecipe:(Recipe *)recipe {
    _recipe = recipe;
    
    self.recipeImageView.file = self.recipe.image;
    [self.recipeImageView loadInBackground];
    
    self.recipeNameLabel.text = self.recipe.name;
    
}
@end
