//
//  CommentCell.m
//  Feast-fbu
//
//  Created by Jessica Au on 7/25/18.
//  Copyright © 2018 jessjessandtre. All rights reserved.
//

#import "CommentCell.h"

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
    self.commentLabel.text = self.comment.text;
}

@end
