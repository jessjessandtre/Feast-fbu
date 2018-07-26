//
//  FriendsTableViewCell.h
//  Feast-fbu
//
//  Created by Trevon Wiggs on 7/25/18.
//  Copyright © 2018 jessjessandtre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import <PTEHorizontalTableView/PTEHorizontalTableView.h>
#import "Post.h"

@interface FriendsTableViewCell : UITableViewCell

@property (strong, nonatomic) Post *post;
@property (weak, nonatomic) IBOutlet PTEHorizontalTableView *friendsTableView;
@property (weak, nonatomic) IBOutlet PFImageView *postImage;

- (void)setPost;

@end
