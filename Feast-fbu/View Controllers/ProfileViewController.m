//
//  ProfileViewController.m
//  Feast-fbu
//
//  Created by Jessica Shu on 7/19/18.
//  Copyright © 2018 jessjessandtre. All rights reserved.
//

#import "AppDelegate.h"
#import "ProfileViewController.h"
#import "Post.h"
#import "LoginViewController.h"
#import "RecipeCollectionViewCell.h"
#import <SVProgressHUD.h>
#import "DetailedPostViewController.h"
#import "CreatePostViewController.h"

@interface ProfileViewController () <UICollectionViewDelegate, UICollectionViewDataSource,  UINavigationControllerDelegate, PostUpdateDelegate>

@property (weak, nonatomic) IBOutlet UILabel *numberFollowersLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberFollowingLabel;

@property (strong, nonatomic) IBOutlet UIImageView *profileImageView;
@property (strong, nonatomic) IBOutlet UILabel *usernameLabel;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong, nonatomic) NSArray* posts;
@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    // temporarily setting user to current user until multiple profile page viewing is allowed
    self.user = [PFUser currentUser];
    
    [self getNumberFollowing];
    [self getNumberFollowers];
    
    self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width / 2;
    self.profileImageView.layer.borderColor = [UIColor greenColor].CGColor;
    self.profileImageView.layer.borderWidth = 1.5;
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    
    layout.minimumInteritemSpacing = 3;
    layout.minimumLineSpacing = 3;
    
    CGFloat postsPerLine = 3;
    CGFloat itemWidth = (self.collectionView.frame.size.width -  layout.minimumInteritemSpacing * (postsPerLine - 1))/ postsPerLine;
    CGFloat itemHeight = itemWidth;
    layout.itemSize = CGSizeMake(itemWidth,itemHeight);
    [SVProgressHUD show];
    [self refreshData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)fetchPosts {
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    [query orderByDescending:@"createdAt"];
    [query includeKey:@"user"];
    [query whereKey:@"user" equalTo:[PFUser currentUser]];

    
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable parsePosts, NSError * _Nullable error) {
        [SVProgressHUD dismiss];
        if (!error){
            NSLog(@"fetched posts successfully");
            self.posts = parsePosts;
            [self.collectionView reloadData];
        }
        else {
            NSLog(@"error fetching posts: %@", error.localizedDescription);

        }
    }];

}

- (void) refreshData {
    [self fetchPosts];
    self.usernameLabel.text = [PFUser currentUser].username;
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
  /*  MovieCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MovieCollectionViewCell" forIndexPath:indexPath];
    
    NSDictionary *movie = self.movies[indexPath.item];
    
    NSString *baseURLString = @"https://image.tmdb.org/t/p/w500";
    NSString *posterURLString = movie[@"poster_path"];
    NSString *fullPosterURLString = [baseURLString stringByAppendingString:posterURLString];
    
    NSURL *posterURL  = [NSURL URLWithString:fullPosterURLString];
    cell.posterView.image = nil;
    [cell.posterView setImageWithURL:posterURL];*/
    
    RecipeCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RecipeCollectionViewCell" forIndexPath:indexPath];
    Post* post = self.posts[indexPath.item];
    cell.post = post;
    return cell;
    
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.posts.count;
}

- (void) didCreatePost {
    [self refreshData];
    [self.collectionView reloadData];
}

// In a storyboard-based application, you will often want to do a little preparation before navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"DetailedPostSegue"]){
        RecipeCollectionViewCell* cell = (RecipeCollectionViewCell*) sender;
        DetailedPostViewController* detailedPostViewController = [segue destinationViewController];
        detailedPostViewController.post = cell.post;
    }
}



- (IBAction)didTapLogout:(id)sender {
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"There was an error logging out.");
        } else {
            AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
            appDelegate.window.rootViewController = loginViewController;
        }
    }];
}

- (void) getNumberFollowing {
    PFQuery *query = [PFQuery queryWithClassName:@"Follow"];
    [query whereKey:@"from_user" equalTo:self.user];
    [query countObjectsInBackgroundWithBlock:^(int number, NSError * _Nullable error) {
        self.numberFollowersLabel.text = [NSString stringWithFormat:@"%d", number];
    }];
}

- (void) getNumberFollowers {
    PFQuery *query = [PFQuery queryWithClassName:@"Follow"];
    [query whereKey:@"to_user" equalTo:self.user];
    [query countObjectsInBackgroundWithBlock:^(int number, NSError * _Nullable error) {
        self.numberFollowingLabel.text = [NSString stringWithFormat:@"%d", number];
    }];
}

- (void) getPosts {
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    [query orderByDescending:@"createdAt"];
    [query includeKey:@"author"];
    [query whereKey:@"authorUsername" equalTo:self.user.username];
    
    query.limit = 20;
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError * _Nullable error) {
        if (posts != nil) {
            self.posts = posts;
            [self.collectionView reloadData];
        } else {
            NSLog(@"Error%@", error.localizedDescription);
        }
    }];
}


@end
