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
    UICollectionViewFlowLayout *collectionViewLayout = (UICollectionViewFlowLayout*) self.postCollectionView.collectionViewLayout;
    
    collectionViewLayout.minimumInteritemSpacing = 0;
    collectionViewLayout.minimumLineSpacing = 2;
    collectionViewLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    UICollectionViewFlowLayout *tagCollectionViewLayout = (UICollectionViewFlowLayout*) self.tagCollectionView.collectionViewLayout;
    
    tagCollectionViewLayout.estimatedItemSize = CGSizeMake(1.f, 1.f);
    tagCollectionViewLayout.minimumInteritemSpacing = 0;
    tagCollectionViewLayout.minimumLineSpacing = 10;
    tagCollectionViewLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    self.saveButton.layer.cornerRadius = self.saveButton.frame.size.width / 2;
    
    /*
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = self.saveButton.bounds;
    gradientLayer.colors = [NSArray arrayWithObjects:(id)[UIColor whiteColor].CGColor, (id)[UIColor clearColor].CGColor, nil];
    gradientLayer.startPoint = CGPointMake(0.0f, 1.0f);
    gradientLayer.endPoint = CGPointMake(1.0f, 1.0f);
    self.saveButton.layer.mask = gradientLayer;
    */

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
    
    [self updateSaveButton];
    
    NSMutableAttributedString* attrString = [[NSMutableAttributedString alloc] initWithString:@"View original recipe"];
    [attrString addAttribute:NSLinkAttributeName value:self.recipe.sourceURL range:NSMakeRange(0, attrString.length)];
    self.urlTextView.attributedText = attrString;
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
