//
//  CourseTypeTableViewCell.h
//  Feast-fbu
//
//  Created by Jessica Au on 8/3/18.
//  Copyright © 2018 jessjessandtre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CourseType.h"

@interface CourseTypeTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *courseTypeImageView;
@property (weak, nonatomic) IBOutlet UILabel *courseTypeLabel;

@property (strong, nonatomic) CourseType *courseType; 

- (void)setCourseType;

@end
