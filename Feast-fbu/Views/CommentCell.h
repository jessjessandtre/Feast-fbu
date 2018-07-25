//
//  CommentCell.h
//  Feast-fbu
//
//  Created by Jessica Au on 7/25/18.
//  Copyright © 2018 jessjessandtre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Comment.h"

@interface CommentCell : UITableViewCell

@property (strong, nonatomic) Comment *comment;

@property (weak, nonatomic) IBOutlet UILabel *commentLabel;

- (void) setComment; 

@end
