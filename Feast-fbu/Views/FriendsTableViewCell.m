//
//  FriendsTableViewCell.m
//  Feast-fbu
//
//  Created by Trevon Wiggs on 7/25/18.
//  Copyright © 2018 jessjessandtre. All rights reserved.
//

#import "FriendsTableViewCell.h"
#import "UIImageView+AFNetworking.h"

@implementation FriendsTableViewCell

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
    
}

@end
