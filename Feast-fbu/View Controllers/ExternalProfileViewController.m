//
//  ExternalProfileViewController.m
//  Feast-fbu
//
//  Created by Jessica Au on 7/23/18.
//  Copyright © 2018 jessjessandtre. All rights reserved.
//

#import "ExternalProfileViewController.h"
#import "Post.h"
#import "PostCollectionViewCell.h"
#import "Follow.h"
#import <Parse/Parse.h>
#import "ParseUI.h"
#import <SVProgressHUD.h>
#import "DetailedPostViewController.h"
#import "FollowViewController.h"

@interface ExternalProfileViewController () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet PFImageView *profileImage;
@property (weak, nonatomic) IBOutlet UICollectionView *externalPostCollectionView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;

@property (weak, nonatomic) IBOutlet UILabel *numberFollowersLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberFollowingLabel;
@property (strong, nonatomic) IBOutlet UIButton *followButton;

@property (strong, nonatomic) NSArray *posts;

@end

@implementation ExternalProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@",self.user.username);
    self.externalPostCollectionView.delegate = self;
    self.externalPostCollectionView.dataSource = self;

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveNotification:)
     
                                                 name:@"FollowUpdateNotification"
                                               object:nil];
    
    self.profileImage.layer.cornerRadius = self.profileImage.frame.size.width / 2;
    self.profileImage.clipsToBounds = YES;
    
    self.profileImage.layer.borderColor = [UIColor colorWithRed:0.91 green:0.91 blue:0.91 alpha:1.0].CGColor;
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

- (void) receiveNotification: (NSNotification *) notification {
    if ([[notification name] isEqualToString:@"NewPostNotification"]) {
        NSLog (@"Successfully received the post notification!");
        [self fetchPosts];
    }
    else if ([[notification name] isEqualToString:@"FollowUpdateNotification"]) {
        NSLog(@"Successfully received the follow notification!");
        [self refreshData];
    }
    
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
            [[NSNotificationCenter defaultCenter]
             postNotificationName:@"FollowUpdateNotification"
             object:nil];
        }
    }];
}

- (void) unfollowUser {
    [Follow unFollowUser:self.user fromUser:[PFUser currentUser] withCompletion:^(Boolean succeeded) {
        if (succeeded) {
            [self getNumberFollowers];
            [self.followButton setSelected:NO];
            [[NSNotificationCenter defaultCenter]
             postNotificationName:@"FollowUpdateNotification"
             object:nil];
        }
    }];
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    PostCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PostCollectionViewCell" forIndexPath:indexPath];
    cell.postImageView.image = nil; 
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
}

- (void) getNumberFollowers {
    [Follow numberOfFollowers:self.user withCompletion:^(int followers) {
        if (followers != -1){
            self.numberFollowersLabel.text = [NSString stringWithFormat:@"%d", followers];
        }
    }];
    
}

- (void) fetchPosts {
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    [query orderByDescending:@"createdAt"];
    [query includeKey:@"user"];
    [query includeKey:@"recipe"];
    [query whereKey:@"user" equalTo:self.user];
    
    query.limit = 20;
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError * _Nullable error) {
        [SVProgressHUD dismiss];
        if (posts != nil) {
            self.posts = posts;
            [self.externalPostCollectionView reloadData];
            NSLog(@"post \n\n\n %@", self.posts);
        } else {
            NSLog(@"Error%@", error.localizedDescription);
            [self alertControlWithTitle:@"Error fetching data" andMessage:error.localizedDescription];
        }
    }];
    
}

- (void) refreshData {
    [self fetchPosts];
    
    self.usernameLabel.text = self.user.username;
    [self getNumberFollowers];
    [self getNumberFollowing];
    
    if (self.user[@"profileImage"] == nil) {
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
    NSLog(@"refresh data");
}

-(void)alertControlWithTitle:(NSString*)title andMessage:(NSString*)message {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:title message:message  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //handle response
    }];
    
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:^{
        // code for after alert controller has finished presenting
    }];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"DetailedPostSegue4"]){
        PostCollectionViewCell* cell = (PostCollectionViewCell*) sender;
        DetailedPostViewController* detailedPostViewController = [segue destinationViewController];
        detailedPostViewController.post = cell.post;
    }
    else if ([segue.identifier isEqualToString:@"FollowersSegue2"]) {
        FollowViewController *followViewController = [segue destinationViewController];
        followViewController.user = self.user;
        followViewController.followOrFollowing = @"Followers";
    }
    else if ([segue.identifier isEqualToString:@"FollowingSegue2"]) {
        FollowViewController *followViewController = [segue destinationViewController];
        followViewController.user = self.user;
        followViewController.followOrFollowing = @"Following";
    }
}


@end
