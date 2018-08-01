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
}

@end
