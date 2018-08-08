//
//  LeaderboardViewController.h
//  Feast-fbu
//
//  Created by Trevon Wiggs on 7/19/18.
//  Copyright © 2018 jessjessandtre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"
#import "ParseUI.h"
#import "Recipe.h"

@interface LeaderboardViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) Recipe *recipe;

@end
