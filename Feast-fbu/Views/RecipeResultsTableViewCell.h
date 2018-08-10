//
//  RecipeResultsTableViewCell.h
//  Feast-fbu
//
//  Created by Jessica Shu on 8/3/18.
//  Copyright © 2018 jessjessandtre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Recipe.h"
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import "MGSwipeTableCell.H"

@interface RecipeResultsTableViewCell : MGSwipeTableCell

@property (strong, nonatomic) Recipe* recipe;
@property (strong, nonatomic) IBOutlet PFImageView *recipeImageView;
@property (strong, nonatomic) IBOutlet UILabel *recipeNameLabel;

@end
