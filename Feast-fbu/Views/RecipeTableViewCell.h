//
//  RecipeTableViewCell.h
//  Feast-fbu
//
//  Created by Jessica Au on 7/19/18.
//  Copyright © 2018 jessjessandtre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Recipe.h"
#import "MGSwipeTableCell.H"
#import <ParseUI/ParseUI.h>

@interface RecipeTableViewCell : MGSwipeTableCell
@property (weak, nonatomic) IBOutlet PFImageView *recipeImageView;
@property (weak, nonatomic) IBOutlet UILabel *recipeTitleLabel;

@property (strong, nonatomic) Recipe *recipe;

@property (nonatomic, assign) BOOL titleShown;

- (void) setRecipe;

@end
