//
//  SuggestedViewController.m
//  Feast-fbu
//
//  Created by Trevon Wiggs on 7/26/18.
//  Copyright © 2018 jessjessandtre. All rights reserved.
//

#import <SVProgressHUD.h>
#import "SuggestedViewController.h"
#import "SuggestedTableViewCell.h"
#import "ExternalProfileViewController.h"

@interface SuggestedViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSArray *users;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SuggestedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self fetchUsers];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)fetchUsers {
    PFQuery *query = [PFQuery queryWithClassName:@"_User"];
    [query whereKey:@"username"notEqualTo:[PFUser currentUser].username];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable parseUsers, NSError * _Nullable error) {
        [SVProgressHUD dismiss];
        if (!error){
            NSLog(@"fetched posts successfully");
            self.users = parseUsers;
            [self.tableView reloadData];
        }
        else {
            NSLog(@"error fetching posts: %@", error.localizedDescription);
            [self alertControlWithTitle:@"Error fetching data" andMessage:error.localizedDescription];
            
        }
    }];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SuggestedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SuggestedCell" forIndexPath:indexPath];
    
    PFUser *user = self.users[indexPath.row];
    cell.user = user;
    [cell setUser];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.users.count;
}

-(void)alertControlWithTitle:(NSString*)title andMessage:(NSString*)message {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:title message:message  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:^{
    }];
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    ExternalProfileViewController *profileController = [segue destinationViewController];
    UITableViewCell *tappedCell = sender;
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
    
    PFUser *user = self.users[indexPath.row];
    NSLog(@"%@", user);
    profileController.user = user;
}


@end
