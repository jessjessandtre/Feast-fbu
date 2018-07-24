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

@interface ExternalProfileViewController () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *externalPostCollectionView;

@property (weak, nonatomic) IBOutlet UILabel *numberFollowersLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberFollowingLabel;



@property (weak, nonatomic) NSArray *posts;

@end

@implementation ExternalProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.externalPostCollectionView.delegate = self;
    self.externalPostCollectionView.dataSource = self;
    
    [self getPosts];
    [self getNumberFollowers];
    [self getNumberFollowing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)followButtonTapped:(id)sender {
    PFObject *followActivity = [PFObject objectWithClassName:@"Follow"];
    [followActivity setObject:[PFUser currentUser] forKey:@"from_user"];
    [followActivity setObject:self.user forKey:@"to_user"];
    [followActivity saveEventually];
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
    PFQuery *query = [PFQuery queryWithClassName:@"Follow"];
    [query whereKey:@"from_user" equalTo:self.user];
    [query countObjectsInBackgroundWithBlock:^(int number, NSError * _Nullable error) {
        self.numberFollowingLabel.text = [NSString stringWithFormat:@"%d", number];
    }];
}

- (void) getNumberFollowers {
    PFQuery *query = [PFQuery queryWithClassName:@"Follow"];
    [query whereKey:@"to_user" equalTo:self.user];
    [query countObjectsInBackgroundWithBlock:^(int number, NSError * _Nullable error) {
        self.numberFollowersLabel.text = [NSString stringWithFormat:@"%d", number];
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
            [self.externalPostCollectionView reloadData];
        } else {
            NSLog(@"Error%@", error.localizedDescription);
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
