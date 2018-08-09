//
//  FollowViewController.m
//  Feast-fbu
//
//  Created by Jessica Au on 8/8/18.
//  Copyright © 2018 jessjessandtre. All rights reserved.
//

#import "FollowViewController.h"
#import <Parse/Parse.h>
#import "Follow.h"
#import "SuggestedTableViewCell.h"
#import "ExternalProfileViewController.h"

@interface FollowViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *followTableView;
@property (strong, nonatomic) NSMutableArray *follows;

@end

@implementation FollowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.followTableView.delegate = self;
    self.followTableView.dataSource = self;
    
    self.navigationItem.title = self.followOrFollowing;
    
    [self fetchFollows];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) fetchFollows {
    
    if ([self.followOrFollowing isEqualToString:@"Followers"]) {
        PFQuery *followersQuery = [PFQuery queryWithClassName:@"Follow"];
        [followersQuery includeKey:@"fromUser"];
        [followersQuery whereKey:@"toUser" equalTo:self.user];
        
        [followersQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable follows, NSError * _Nullable error) {
            self.follows = [NSMutableArray array];

            if (!error) {
                for (Follow *u in follows) {
                    [self.follows addObject:u.fromUser];
                }
            }
            else {
                NSLog(@"error fetching followers: %@", error.localizedDescription);
            }
            
            [self.followTableView reloadData];
        }];
    }
    else if ([self.followOrFollowing isEqualToString:@"Following"]) {
        PFQuery *followersQuery = [PFQuery queryWithClassName:@"Follow"];
        [followersQuery includeKey:@"toUser"];
        [followersQuery whereKey:@"fromUser" equalTo:self.user];
        
        [followersQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable follows, NSError * _Nullable error) {
            self.follows = [NSMutableArray array];

            if (!error) {
                for (Follow *u in follows) {
                    [self.follows addObject:u.toUser];
                }
            }
            else {
                NSLog(@"error fetching followings: %@", error.localizedDescription);
            }
            
            [self.followTableView reloadData];
        }];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SuggestedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SuggestedCell" forIndexPath:indexPath];
    PFUser *user = self.follows[indexPath.row];
    cell.user = user;
    [cell setUser];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.follows.count;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"ExternalProfileSegue5"]) {
        ExternalProfileViewController *externalProfileViewController = [segue destinationViewController];
        externalProfileViewController.user = self.user;
    }
}


@end
