//
//  CreatePostViewController.h
//  Feast-fbu
//
//  Created by Jessica Shu on 7/19/18.
//  Copyright © 2018 jessjessandtre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "Post.h"

@interface CreatePostViewController : UIViewController

@property (strong, nonatomic) UIImage* image;
@property (strong, nonatomic) Recipe* recipe;

@end 


