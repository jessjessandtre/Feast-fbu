//
//  RecipeCollectionViewCell.h
//  Feast-fbu
//
//  Created by Jessica Shu on 7/19/18.
//  Copyright © 2018 jessjessandtre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>

@interface RecipeCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet PFImageView *postImageView;

@end
