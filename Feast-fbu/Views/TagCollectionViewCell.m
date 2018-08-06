//
//  TagCollectionViewCell.m
//  Feast-fbu
//
//  Created by Jessica Au on 8/3/18.
//  Copyright © 2018 jessjessandtre. All rights reserved.
//

#import "TagCollectionViewCell.h"

@implementation TagCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentView.translatesAutoresizingMaskIntoConstraints = NO;

}

- (void) setTagName:(NSString *)tagName {
    _tagName = tagName;
    
    self.tagLabel.text = tagName;
    NSLog(@"tag label %@", self.tagLabel.text);
}
@end
