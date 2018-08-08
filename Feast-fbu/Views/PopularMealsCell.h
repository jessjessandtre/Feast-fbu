//
//  PopularMealsCell.h
//  Feast-fbu
//
//  Created by Trevon Wiggs on 7/19/18.
//  Copyright © 2018 jessjessandtre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Recipe.h"
#import "ParseUI.h"

@interface PopularMealsCell : UITableViewCell

@property (strong, nonatomic) Recipe * recipe;

@property (weak, nonatomic) IBOutlet PFImageView *recipeImage;
@property (weak, nonatomic) IBOutlet UILabel *recipeName;
@property (weak, nonatomic) IBOutlet UILabel *rank;
@property (weak, nonatomic) IBOutlet PFImageView *user1Image;
@property (weak, nonatomic) IBOutlet PFImageView *user2Image;
@property (weak, nonatomic) IBOutlet PFImageView *user3Image;


@end
