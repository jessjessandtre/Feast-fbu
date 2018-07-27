//
//  SuggestedTableViewCell.h
//  Feast-fbu
//
//  Created by Trevon Wiggs on 7/26/18.
//  Copyright © 2018 jessjessandtre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Parse/Parse.h"
#import "ParseUI.h"

@interface SuggestedTableViewCell : UITableViewCell

@property (strong, nonatomic) PFUser *user;

@property (weak, nonatomic) IBOutlet PFImageView *profilePic;
@property (weak, nonatomic) IBOutlet UILabel *username;

-(void)setUser;

@end
