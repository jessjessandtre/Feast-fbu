//
//  RecipePostCollectionViewCell.h
//  Feast-fbu
//
//  Created by Jessica Au on 7/26/18.
//  Copyright © 2018 jessjessandtre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>

@interface RecipePostCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet PFImageView *postImageView;

@property (strong, nonatomic) Post *post;

- (void) setPost; 

@end
