//
//  ProfileViewController.h
//  Feast-fbu
//
//  Created by Jessica Shu on 7/19/18.
//  Copyright © 2018 jessjessandtre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@protocol ProfileViewControllerDelegate

- (void)didUpdateProfilePicture;

@end;

@interface ProfileViewController : UIViewController

@property (strong, nonatomic) UIImage *profileImage; 
@property (strong, nonatomic) PFUser *user;

@property (weak, nonatomic) id<ProfileViewControllerDelegate> delegate;

- (IBAction)didTapLogout:(id)sender;

@end
