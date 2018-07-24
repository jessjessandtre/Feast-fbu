//
//  TimelineViewCell.h
//  Feast-fbu
//
//  Created by Trevon Wiggs on 7/23/18.
//  Copyright © 2018 jessjessandtre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import "Post.h"

@interface TimelineViewCell : UITableViewCell

@property (strong, nonatomic) Post *post;

@property (nonatomic, strong) NSString *createdAt;

@property (weak, nonatomic) IBOutlet PFImageView *postImage;
@property (weak, nonatomic) IBOutlet PFImageView *profilePicture;

@property (weak, nonatomic) IBOutlet UILabel *postAuthorHeader;
@property (weak, nonatomic) IBOutlet UILabel *postAuthorCaption;
@property (weak, nonatomic) IBOutlet UILabel *recipeName;
@property (weak, nonatomic) IBOutlet UILabel *postCaption;
@property (weak, nonatomic) IBOutlet UILabel *postTimestamp;

- (IBAction)didTapLike:(id)sender;
- (IBAction)didTapComment:(id)sender;
- (IBAction)didTapShare:(id)sender;

- (void)setPost;

@end
