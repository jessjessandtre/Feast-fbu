//
//  ExternalProfileViewController.m
//  Feast-fbu
//
//  Created by Jessica Au on 7/23/18.
//  Copyright © 2018 jessjessandtre. All rights reserved.
//

#import "ExternalProfileViewController.h"
#import "Post.h"
#import "ExternalUserCollectionViewCell.h"
#import "Follow.h"
#import <Parse/Parse.h>
#import "ParseUI.h"
#import <SVProgressHUD.h>

@interface ExternalProfileViewController () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet PFImageView *profileImage;
@property (weak, nonatomic) IBOutlet UICollectionView *externalPostCollectionView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;

@property (weak, nonatomic) IBOutlet UILabel *numberFollowersLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberFollowingLabel;
@property (strong, nonatomic) IBOutlet UIButton *followButton;



@property (weak, nonatomic) NSArray *posts;

@end

@implementation ExternalProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@",self.user.username);
    self.externalPostCollectionView.delegate = self;
    self.externalPostCollectionView.dataSource = self;

    
    self.profileImage.layer.cornerRadius = self.profileImage.frame.size.width / 2;
    self.profileImage.clipsToBounds = YES;
    
    self.profileImage.layer.borderColor = [UIColor greenColor].CGColor;
    self.profileImage.layer.borderWidth = 1.5;
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.externalPostCollectionView.collectionViewLayout;
    
    layout.minimumInteritemSpacing = 3;
    layout.minimumLineSpacing = 3;
    
    CGFloat postsPerLine = 3;
    CGFloat itemWidth = (self.externalPostCollectionView.frame.size.width -  layout.minimumInteritemSpacing * (postsPerLine - 1))/ postsPerLine;
    CGFloat itemHeight = itemWidth;
    layout.itemSize = CGSizeMake(itemWidth,itemHeight);
    
    [SVProgressHUD show];
    
    [self refreshData];
}



- (IBAction)followButtonTapped:(id)sender {
    if ([self.followButton isSelected]){
        [self unfollowUser];
    }
    else {
        [self followUser];
    }
}

- (void) followUser {
    [Follow followUser:self.user fromUser:[PFUser currentUser] withCompletion:^(Boolean succeeded) {
        if (succeeded){
            [self getNumberFollowers];
            [self.followButton setSelected:YES];
        }
    }];
/*    PFObject *followActivity = [PFObject objectWithClassName:@"Follow"];
    [followActivity setObject:[PFUser currentUser] forKey:@"fromUser"];
    [followActivity setObject:self.user forKey:@"toUser"];
    [followActivity saveEventually];
    [self getNumberFollowers];
 */
}

- (void) unfollowUser {
    [Follow unFollowUser:self.user fromUser:[PFUser currentUser] withCompletion:^(Boolean succeeded) {
        if (succeeded) {
            [self getNumberFollowers];
            [self.followButton setSelected:NO];
        }
    }];
    /*
    PFQuery *query = [PFQuery queryWithClassName:@"Follow"];
    [query whereKey:@"fromUser" equalTo:[PFUser currentUser]];
    [query whereKey:@"toUser" equalTo:self.user];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
        if (object) {
            [object deleteInBackground];
        }
        else {
            NSLog(@"Unable to retrieve object");
        }
    }];
    [self getNumberFollowers];
    */
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    ExternalUserCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ExternalPostCell" forIndexPath:indexPath];
    Post* post = self.posts[indexPath.item];
    cell.post = post;
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.posts.count;
}

- (void) getNumberFollowing {
    [Follow numberOfFollowing:self.user withCompletion:^(int following) {
        if (following != -1){
            self.numberFollowingLabel.text = [NSString stringWithFormat:@"%d", following];
        }
    }];
    /*
    PFQuery *query = [PFQuery queryWithClassName:@"Follow"];
    [query whereKey:@"fromUser" equalTo:self.user];
    [query countObjectsInBackgroundWithBlock:^(int number, NSError * _Nullable error) {
        self.numberFollowingLabel.text = [NSString stringWithFormat:@"%d", number];
    }];
    */
}

- (void) getNumberFollowers {
    [Follow numberOfFollowers:self.user withCompletion:^(int followers) {
        if (followers != -1){
            self.numberFollowersLabel.text = [NSString stringWithFormat:@"%d", followers];
        }
    }];
    /*
    PFQuery *query = [PFQuery queryWithClassName:@"Follow"];
    [query whereKey:@"toUser" equalTo:self.user];
    [query countObjectsInBackgroundWithBlock:^(int number, NSError * _Nullable error) {
        self.numberFollowersLabel.text = [NSString stringWithFormat:@"%d", number];
    }];
    */
}

- (void) getPosts {
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    [query orderByDescending:@"createdAt"];
    [query includeKey:@"user"];
    [query whereKey:@"user" equalTo:self.user];
    
    query.limit = 20;
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError * _Nullable error) {
        [SVProgressHUD dismiss];
        if (posts != nil) {
            self.posts = posts;
            [self.externalPostCollectionView reloadData];
        } else {
            NSLog(@"Error%@", error.localizedDescription);
        }
    }];
}

- (void) refreshData {
    [self getPosts];
    
    self.usernameLabel.text = self.user.username;
    [self getNumberFollowers];
    [self getNumberFollowing];
    
    if (self.user[@"profileImage"] == [NSNull null]) {
        self.profileImage.image = [UIImage imageNamed: @"profile-image-blank"];
    }
    else {
        self.profileImage.file = self.user[@"profileImage"];
        [self.profileImage loadInBackground];
    }
    
    [Follow userIsFollowing:self.user fromUser:[PFUser currentUser] withCompletion:^(Boolean followed) {
        if (followed){
            [self.followButton setSelected:YES];
        }
        else {
            [self.followButton setSelected:NO];
        }
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
