//
//  PostCollectionViewCell.h
//  Feast-fbu
//
//  Created by Jessica Shu on 8/1/18.
//  Copyright © 2018 jessjessandtre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>

@interface PostCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet PFImageView *postImageView;

@property (strong, nonatomic) Post* post;

@end
