//
//  ExternalUserCollectionViewCell.m
//  Feast-fbu
//
//  Created by Jessica Au on 7/23/18.
//  Copyright © 2018 jessjessandtre. All rights reserved.
//

#import "ExternalUserCollectionViewCell.h"

@implementation ExternalUserCollectionViewCell

- (void) setPost:(Post *)post {
    _post = post;
    
    self.postImageView.file = post.image;
    [self.postImageView loadInBackground];
}

@end
