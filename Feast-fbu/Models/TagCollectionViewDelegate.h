//
//  TagCollectionViewDelegate.h
//  Feast-fbu
//
//  Created by Jessica Shu on 8/7/18.
//  Copyright © 2018 jessjessandtre. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TagCollectionViewDelegate : NSObject <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSArray* tags;

@end
