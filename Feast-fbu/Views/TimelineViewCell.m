//
//  TimelineViewCell.m
//  Feast-fbu
//
//  Created by Trevon Wiggs on 7/23/18.
//  Copyright © 2018 jessjessandtre. All rights reserved.
//

#import "TimelineViewCell.h"
#import "DateTools.h"
#import "UIImageView+AFNetworking.h"

@implementation TimelineViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setPost {
    NSLog(@"%@", self.post);
    self.postImage.file = self.post.image;
    [self.postImage loadInBackground];
   
    // Creates a circle frame for the profile pic
    self.profilePicture.layer.cornerRadius = self.profilePicture.frame.size.width / 2;
    
    self.postAuthorHeader.text = self.post.user.username;
    self.postAuthorCaption.text = self.post.user.username;
    self.postCaption.text = self.post.caption;
    
    Recipe* recipe = self.post.recipe;
    [recipe fetchInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
        if (object){
            self.recipeName.text = self.post.recipe.name;
        }
        else {
            NSLog(@"error loading recipe: %@", error.localizedDescription);
            self.recipeName.text = @"";
        }
    }];
    
    
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
