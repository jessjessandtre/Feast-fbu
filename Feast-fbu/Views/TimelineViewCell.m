//
//  TimelineViewCell.m
//  Feast-fbu
//
//  Created by Trevon Wiggs on 7/23/18.
//  Copyright © 2018 jessjessandtre. All rights reserved.
//

#import "TimelineViewCell.h"
#import "DateTools.h"

@implementation TimelineViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setPost:(Post *)post {
    _post = post;
    
    self.postImage.file = post[@"image"];
    [self.postImage loadInBackground];
    test
    
    // Creates a circle frame for the profile pic
    self.profilePicture.layer.cornerRadius = self.profilePicture.frame.size.width / 2;
    
    self.postAuthorHeader.text = post.user.username;
    self.postAuthorCaption.text = post.user.username;
    self.recipeName.text = post.recipe;
    //self.postCaption.text = post.caption;
    
    
    // Format createdAt date string
    NSDate *createdAtOriginalString = self.post.createdAt;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // Configure the input format to parse the date string
    formatter.dateFormat = @"E MMM d HH:mm:ss Z y";
    
    //Convert String to timeAgo
    NSString *timeAgoDate = [NSDate shortTimeAgoSinceDate:createdAtOriginalString];
    self.createdAt = timeAgoDate;
    self.postTimestamp.text = self.createdAt;
    
    
}

- (IBAction)didTapLike:(id)sender {
}

- (IBAction)didTapComment:(id)sender {
}

- (IBAction)didTapShare:(id)sender {
}
@end
