//
//  FriendsCollectionViewCell.m
//  Feast-fbu
//
//  Created by Trevon Wiggs on 7/25/18.
//  Copyright © 2018 jessjessandtre. All rights reserved.
//

#import "FriendsCollectionViewCell.h"
#import "UIImageView+AFNetworking.h"

@implementation FriendsCollectionViewCell

- (void)setPost {
    NSLog(@"%@", self.post);
    self.postImage.file = self.post.image;
    [self.postImage loadInBackground];
}

@end

