//
//  RecipeTableViewCell.m
//  Feast-fbu
//
//  Created by Jessica Au on 7/19/18.
//  Copyright © 2018 jessjessandtre. All rights reserved.
//

#import "RecipeTableViewCell.h"
#import "UIImageView+AFNetworking.h"

@implementation RecipeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.titleShown = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setRecipe {
    NSString *recipeImageURLString = self.recipe.image.url;
    NSURL *recipeImageURL = [NSURL URLWithString:recipeImageURLString];
    [self.recipeImageView setImageWithURL:recipeImageURL];
    
    // self.recipeImageView.contentMode = UIViewContentModeScaleAspectFit;
    // self.recipeImageView.layer.cornerRadius = self.recipeImageView.frame.size.width / 32;
    // self.recipeImageView.clipsToBounds = YES;
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = self.bounds;
    gradientLayer.colors = @[(id)[UIColor clearColor].CGColor, (id)[UIColor grayColor].CGColor];
    gradientLayer.startPoint = CGPointMake(0.5f, 0.7f);
    gradientLayer.endPoint = CGPointMake(0.5f, 1.2f);
    
    self.recipeTitleLabel.hidden = NO;
    self.recipeTitleLabel.text = self.recipe.name;
    
}

@end
