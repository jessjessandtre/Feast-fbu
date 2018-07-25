//
//  SavedRecipesCollectionViewCell.h
//  Feast-fbu
//
//  Created by Jessica Shu on 7/25/18.
//  Copyright © 2018 jessjessandtre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Recipe.h"
#import <ParseUI/ParseUI.h>

@interface SavedRecipesCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) Recipe* recipe;
@property (strong, nonatomic) IBOutlet PFImageView *recipeImageView;

@end
