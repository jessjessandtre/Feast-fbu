//
//  PostCollectionViewCell.m
//  Feast-fbu
//
//  Created by Jessica Shu on 8/1/18.
//  Copyright © 2018 jessjessandtre. All rights reserved.
//

#import "PostCollectionViewCell.h"

@implementation PostCollectionViewCell

- (void) setPost:(Post *)post {
    _post = post;
    
    self.postImageView.file = post.image;
    [self.postImageView loadInBackground];
    
    if (self.post.user[@"profileImage"] == nil) {
        self.profileImageView.image = [UIImage imageNamed: @"profile-image-blank"];
    }
    else {
        self.profileImageView.file = self.post.user[@"profileImage"];
        [self.profileImageView loadInBackground];
    }
    
    self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width / 2;
    
    
}

@end
