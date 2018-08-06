//
//  RecipeResultsViewController.h
//  Feast-fbu
//
//  Created by Jessica Shu on 8/3/18.
//  Copyright © 2018 jessjessandtre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CourseType.h"

@interface RecipeResultsViewController : UIViewController

@property (strong, nonatomic) CourseType* courseType;
@property (strong, nonatomic) NSString* tagName;
@property (strong, nonatomic) NSString *searchString;

@end
