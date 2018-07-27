//
//  RecipePostCollectionViewCell.m
//  Feast-fbu
//
//  Created by Jessica Au on 7/26/18.
//  Copyright © 2018 jessjessandtre. All rights reserved.
//

#import "RecipePostCollectionViewCell.h"
#import "UIImageView+AFNetworking.h"

@implementation RecipePostCollectionViewCell

- (void) setPost {
    self.postImageView.file = self.post.image;
    [self.postImageView loadInBackground];

}

@end
