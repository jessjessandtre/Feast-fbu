//
//  TagCollectionViewCell.h
//  Feast-fbu
//
//  Created by Jessica Au on 8/3/18.
//  Copyright © 2018 jessjessandtre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tag.h"

@interface TagCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *tagLabel;
@property (strong, nonatomic) Tag* tag;
@end
