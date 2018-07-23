//
//  Follow.h
//  Feast-fbu
//
//  Created by Jessica Au on 7/23/18.
//  Copyright © 2018 jessjessandtre. All rights reserved.
//

#import "PFObject.h"

@interface Follow : PFObject

@property (strong, nonatomic) PFUser* fromUser;
@property (strong, nonatomic) PFUser* toUser; 

@end
