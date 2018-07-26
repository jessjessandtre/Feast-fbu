//
//  DetailViewController.h
//  Feast-fbu
//
//  Created by Jessica Au on 7/19/18.
//  Copyright © 2018 jessjessandtre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Recipe.h"
#import <ParseUI/ParseUI.h>

/*
@protocol PostUpdateDelegate

- (void) didCreatePost;

@end
 */

@interface DetailViewController : UIViewController

@property (weak, nonatomic) IBOutlet PFImageView *recipeImageView;
@property (weak, nonatomic) IBOutlet UILabel *recipeTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *ingredientsLabel;
@property (strong, nonatomic) IBOutlet UILabel *instructionsLabel;
@property (strong, nonatomic) IBOutlet UILabel *sourceUrlLabel;
@property (strong, nonatomic) IBOutlet UIButton *saveButton;

@property (strong, nonatomic) Recipe *recipe;

// @property (weak, nonatomic) id<PostUpdateDelegate> delegate;

@end
