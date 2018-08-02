//
//  AutofillResultCellTableViewCell.m
//  Feast-fbu
//
//  Created by Jessica Au on 8/1/18.
//  Copyright © 2018 jessjessandtre. All rights reserved.
//

#import "AutofillResultCellTableViewCell.h"

@implementation AutofillResultCellTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setCell {
    self.tagLabel =[[UILabel alloc]initWithFrame:CGRectMake(10, 70, 50, 50)];//Set frame of label in your viewcontroller.
    [self.tagLabel setBackgroundColor:[UIColor lightGrayColor]];//Set background color of label.
    [self.tagLabel setText:@"Label"];//Set text in label.
    [self.tagLabel setTextColor:[UIColor blackColor]];//Set text color in label.
    [self.tagLabel setTextAlignment:NSTextAlignmentCenter];//Set text alignment in label.
    [self.tagLabel  setBaselineAdjustment:UIBaselineAdjustmentAlignBaselines];//Set line adjustment.
    [self.tagLabel  setLineBreakMode:NSLineBreakByCharWrapping];//Set linebreaking mode..
    [self.tagLabel  setNumberOfLines:1];//Set number of lines in label.
    [self.tagLabel.layer setCornerRadius:25.0];//Set corner radius of label to change the shape.
    [self.tagLabel.layer setBorderWidth:2.0f];//Set border width of label.
    [self.tagLabel setClipsToBounds:YES];//Set its to YES for Corner radius to work.
    [self.tagLabel.layer setBorderColor:[UIColor blackColor].CGColor];//Set Border color.
    [self addSubview:self.tagLabel];//Add it to the view of your choice.
}

@end
