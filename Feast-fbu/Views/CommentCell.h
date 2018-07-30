//
//  CommentCell.h
//  Feast-fbu
//
//  Created by Jessica Au on 7/25/18.
//  Copyright © 2018 jessjessandtre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import "Comment.h"

@interface CommentCell : UITableViewCell

@property (strong, nonatomic) Comment *comment;
@property (strong, nonatomic) PFUser *user;

@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet PFImageView *profileImageView;


- (void) setComment; 

@end
