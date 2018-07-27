//
//  DetailRecipeTableViewCell.h
//  Feast-fbu
//
//  Created by Jessica Au on 7/27/18.
//  Copyright © 2018 jessjessandtre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ParseUI/ParseUI.h>
#import <Parse/Parse.h>
#import "Recipe.h"

@interface DetailRecipeTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet PFImageView *recipeImageView;
@property (weak, nonatomic) IBOutlet UILabel *recipeTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *sourceURLLabel;
@property (weak, nonatomic) IBOutlet UILabel *ingredientsLabel;
@property (weak, nonatomic) IBOutlet UILabel *instructionsLabel;

@property (weak, nonatomic) IBOutlet UIButton *saveButton;

@property (strong, nonatomic) Recipe *recipe;

@end
