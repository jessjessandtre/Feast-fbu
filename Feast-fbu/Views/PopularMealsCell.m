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
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = self.bounds;
    gradientLayer.colors = @[(id)[UIColor clearColor].CGColor, (id)[UIColor grayColor].CGColor];
    gradientLayer.startPoint = CGPointMake(0.5f, 0.7f);
    gradientLayer.endPoint = CGPointMake(0.5f, 1.2f);
    [self.recipeImage.layer insertSublayer:gradientLayer atIndex:0];
    
    // self.recipeImage.layer.cornerRadius = self.recipeImage.frame.size.width / 32;
    
    self.recipeName.text = recipe.name;
    
}

@end
