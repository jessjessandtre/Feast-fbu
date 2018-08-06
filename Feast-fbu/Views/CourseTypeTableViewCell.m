//
//  CourseTypeTableViewCell.m
//  Feast-fbu
//
//  Created by Jessica Au on 8/3/18.
//  Copyright © 2018 jessjessandtre. All rights reserved.
//

#import "CourseTypeTableViewCell.h"

@implementation CourseTypeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCourseType {
    self.courseTypeImageView.image = self.courseType.image;
    self.courseTypeLabel.text = self.courseType.name;
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = self.bounds;
    gradientLayer.colors = @[(id)[UIColor clearColor].CGColor, (id)[UIColor blackColor].CGColor];
    gradientLayer.startPoint = CGPointMake(0.75f, 0.1f);
    gradientLayer.endPoint = CGPointMake(0.0f, 0.1f);
    [self.courseTypeImageView.layer insertSublayer:gradientLayer atIndex:0];
}

@end
