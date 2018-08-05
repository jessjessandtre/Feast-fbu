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
@property (weak, nonatomic) IBOutlet UITableView *recipesTableView;

@end

@implementation LeaderboardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.recipesTableView.delegate = self;
    self.recipesTableView.dataSource = self;
    
    self.navigationItem.title = @"Leaderboard";
    
    [self.recipesTableView setShowsVerticalScrollIndicator:NO];
    
    [SVProgressHUD show];
    [self fetchPopularRecipes];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PopularMealsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PopularMealsCell"];
    
    Recipe *recipe = self.popularRecipes[indexPath.row];
    [cell setRecipe:recipe];
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
        }
        else {
            NSLog(@"%@", error.localizedDescription);
            [self alertControlWithTitle:@"Error fetching data" andMessage:error.localizedDescription];
        }
        
        [self.recipesTableView reloadData];
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
