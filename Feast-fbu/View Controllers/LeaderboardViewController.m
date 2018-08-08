//
//  LeaderboardViewController.m
//  Feast-fbu
//
//  Created by Trevon Wiggs on 7/19/18.
//  Copyright © 2018 jessjessandtre. All rights reserved.
//

#import "RecipeDetailViewController.h"
#import "LeaderboardViewController.h"
#import "PopularMealsCell.h"
#import <SVProgressHUD.h>

@interface LeaderboardViewController ()

@property (nonatomic, strong) NSArray *popularRecipes;
@property (strong, nonatomic) NSArray<PFUser*> *users;
@property (weak, nonatomic) IBOutlet UITableView *recipesTableView;
@property (strong, nonatomic) UIRefreshControl *refreshControl;


@end

@implementation LeaderboardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.recipesTableView.delegate = self;
    self.recipesTableView.dataSource = self;
    
    self.navigationItem.title = @"Popular";
    
    [self.recipesTableView setShowsVerticalScrollIndicator:NO];
    
    [SVProgressHUD show];
    
    [self fetchPopularRecipes];
    
    self.refreshControl = [[UIRefreshControl alloc]init];
    [self.refreshControl addTarget:self action:@selector(fetchPopularRecipes) forControlEvents:UIControlEventValueChanged];
    [self.recipesTableView insertSubview:self.refreshControl atIndex:0];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PopularMealsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PopularMealsCell"];
    
    Recipe *recipe = self.popularRecipes[indexPath.row];
    [cell setRecipe:recipe];
    [self fetchUsers:recipe withBlock:^(Boolean completed) {
        NSLog(@"%@", self.users);
        if (completed){
            if (self.users.count != 0) {
                cell.user1Image.file = self.users[0][@"profileImage"];
                [cell.user1Image loadInBackground];
                
                cell.user1Image.layer.cornerRadius = cell.user1Image.frame.size.width / 2;
                cell.user1Image.clipsToBounds = true;
                cell.user1Image.layer.borderColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0].CGColor;
                cell.user1Image.layer.borderWidth = 1.5;
            }
            if (self.users.count > 1) {
                cell.user2Image.file = self.users[1][@"profileImage"];
                [cell.user2Image loadInBackground];
                
                cell.user2Image.layer.cornerRadius = cell.user2Image.frame.size.width / 2;
                cell.user2Image.clipsToBounds = true;
                cell.user2Image.layer.borderColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0].CGColor;
                cell.user2Image.layer.borderWidth = 1.5;
            }
            if (self.users.count > 2) {
                cell.user3Image.file = self.users[2][@"profileImage"];
                [cell.user3Image loadInBackground];
                
                cell.user3Image.layer.cornerRadius = cell.user3Image.frame.size.width / 2;
                cell.user3Image.clipsToBounds = true;
                cell.user3Image.layer.borderColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0].CGColor;
                cell.user3Image.layer.borderWidth = 1.5;
            }
        }
    }];
    
    cell.rank.text = [NSString stringWithFormat:@"%@", [NSNumber numberWithInteger:indexPath.row + 1]];
    return cell;
    
}

- (NSInteger)tableView:(nonnull UITableView *)recipesTableView numberOfRowsInSection:(NSInteger)section {
    return self.popularRecipes.count;
}

- (void)fetchPopularRecipes {
    PFQuery *recipeQuery = [Recipe query];
    [recipeQuery orderByDescending:@"numPosts"];
    recipeQuery.limit = 10;
    
    [recipeQuery findObjectsInBackgroundWithBlock:^(NSArray<Recipe *> * _Nullable recipes, NSError * _Nullable error) {
        [SVProgressHUD dismiss];
        if (recipes) {
            self.popularRecipes = recipes;
            
            [self.recipesTableView reloadData];
            [self.refreshControl endRefreshing];
        }
        else {
            NSLog(@"%@", error.localizedDescription);
            [self alertControlWithTitle:@"Error fetching data" andMessage:error.localizedDescription];
        }
    }];
}

- (void)fetchUsers: (Recipe *)recipe withBlock:( void(^)(Boolean completed))completion{
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    [query orderByDescending:@"createdAt"];
    [query includeKey:@"recipe"];
    [query includeKey:@"user"];
    [query whereKey:@"recipe" equalTo:recipe];
    
    query.limit = 3;
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError * _Nullable error) {
        if (posts != nil) {
            NSMutableArray *users = [[NSMutableArray alloc] init];
            for (Post *post in posts) {
                [users addObject:post.user];
                NSLog(@"%@", users);
            }
            self.users = users;;
            NSLog(@"%@ ************************************************************************", self.users[0][@"profileImage"]);
            
            completion(true);

        } else {
            NSLog(@"Error%@", error.localizedDescription);
        }
    }];
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
    /*UINavigationController *navigationController = [segue destinationViewController];
    DetailViewController* detailViewController = (DetailViewController*) navigationController.topViewController;
    */
    
    RecipeDetailViewController* detailViewController = [segue destinationViewController];
    UITableViewCell *tappedCell = sender;
    
    NSIndexPath *indexPath = [self.recipesTableView indexPathForCell:tappedCell];
    
    Recipe *recipe = self.popularRecipes[indexPath.row];
    
    detailViewController.recipe = recipe;
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

@end
