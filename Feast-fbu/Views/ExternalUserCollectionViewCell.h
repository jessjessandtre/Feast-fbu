//
//  ExternalUserCollectionViewCell.h
//  Feast-fbu
//
//  Created by Jessica Au on 7/23/18.
//  Copyright © 2018 jessjessandtre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import "Post.h"

@interface ExternalUserCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet PFImageView *postImageView;

@property (strong, nonatomic) Post *post; 

@end
