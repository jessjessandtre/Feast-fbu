//
//  RecipeDetailViewController.h
//  Feast-fbu
//
//  Created by Jessica Au on 7/27/18.
//  Copyright © 2018 jessjessandtre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "Recipe.h"

@interface RecipeDetailViewController : UIViewController

@property (strong, nonatomic) Recipe *recipe;

@end
