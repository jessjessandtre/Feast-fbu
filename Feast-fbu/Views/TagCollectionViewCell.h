//
//  TagCollectionViewCell.h
//  Feast-fbu
//
//  Created by Jessica Au on 8/3/18.
//  Copyright © 2018 jessjessandtre. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TagCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) NSString* tagName;
@property (strong, nonatomic) IBOutlet UILabel *tagLabel;

@end
