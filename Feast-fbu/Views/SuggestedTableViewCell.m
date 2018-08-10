//
//  SuggestedTableViewCell.m
//  Feast-fbu
//
//  Created by Trevon Wiggs on 7/26/18.
//  Copyright © 2018 jessjessandtre. All rights reserved.
//

#import "SuggestedTableViewCell.h"

@implementation SuggestedTableViewCell

-(void)setUser{
    
    self.profilePic.layer.cornerRadius = self.profilePic.frame.size.width / 2;
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
