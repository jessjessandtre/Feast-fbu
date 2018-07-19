//
//  PopularMealsCell.m
//  Feast-fbu
//
//  Created by Trevon Wiggs on 7/19/18.
//  Copyright © 2018 jessjessandtre. All rights reserved.
//

#import "PopularMealsCell.h"
#import "Parse.h"
#import "ParseUI.h"
#import "UIImageView+AFNetworking.h"

@implementation PopularMealsCell

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
    
    self.recipeImage.file = recipe.image;
    [self.recipeImage loadInBackground];
    
    self.recipeName.text = recipe.name;
    
}

@end
