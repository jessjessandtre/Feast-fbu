//
//  CommentCell.m
//  Feast-fbu
//
//  Created by Jessica Au on 7/25/18.
//  Copyright © 2018 jessjessandtre. All rights reserved.
//

#import "CommentCell.h"
#import <Parse/Parse.h>

@implementation CommentCell


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setComment {
    
    [self.comment fetchInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
        if (object){
            self.commentLabel.text = self.comment[@"text"];
            [self fetchUser];
        }
        else {
            NSLog(@"error loading comment: %@", error.localizedDescription);
            self.commentLabel.text = @"";
        }
    }];
}

- (void) fetchUser {
    self.user = self.comment[@"fromUser"];
    
    [self.user fetchInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
        self.usernameLabel.text = self.user[@"username"];
        self.profileImageView.file = self.user[@"profileImage"];
    }];
}
/*
- (void) fetchUser {
    [self.comment[@"fromUser"] fetchInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
        self.usernameLabel.text = self.comment.fromUser[@"username"];
        self.profileImageView.file = self.comment.fromUser[@"profileImage"];
    }];
}
*/
@end
