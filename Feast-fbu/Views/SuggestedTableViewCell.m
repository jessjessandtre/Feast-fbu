//
//  SuggestedTableViewCell.m
//  Feast-fbu
//
//  Created by Trevon Wiggs on 7/26/18.
//  Copyright © 2018 jessjessandtre. All rights reserved.
//

#import "SuggestedTableViewCell.h"

@implementation SuggestedTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setUser{
    if (self.user[@"profileImage"] == nil) {
        self.profilePic.image = [UIImage imageNamed: @"profile-image-blank"];
    }
    else {
        self.profilePic.file = self.user[@"profileImage"];
        [self.profilePic loadInBackground];
    }
    self.username.text = self.user.username;
}

@end
