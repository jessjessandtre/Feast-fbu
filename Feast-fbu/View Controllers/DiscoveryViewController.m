//
//  DiscoveryViewController.m
//  Feast-fbu
//
//  Created by Jessica Au on 7/19/18.
//  Copyright © 2018 jessjessandtre. All rights reserved.
//

#import "DiscoveryViewController.h"
#import <Parse/Parse.h>
#import "Recipe.h"
#import "RecipeTableViewCell.h"
#import "DetailViewController.h"
#import "RecipeTableViewCellHeaderCell.h"

@interface DiscoveryViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@property (strong, nonatomic) IBOutlet UITableView *recipeTableView;
@property (strong, nonatomic) NSArray *recipes;
@property (strong, nonatomic) NSArray *filteredRecipes;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;


@end

@implementation DiscoveryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.recipeTableView.delegate = self;
    self.recipeTableView.dataSource = self;
    self.searchBar.delegate = self;
    
    self.recipeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    [self fetchRecipes];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) fetchRecipes {

    PFQuery *recipeQuery = [Recipe query];
    [recipeQuery orderByDescending:@"createdAt"];
    recipeQuery.limit = 20;
    
    [recipeQuery findObjectsInBackgroundWithBlock:^(NSArray<Recipe *> * _Nullable recipes, NSError * _Nullable error) {
        if (recipes) {
            self.recipes = recipes;
            self.filteredRecipes = self.recipes;
            [self.recipeTableView reloadData];
            

        }
        else {
            NSLog(@"%@", error.localizedDescription);
        }
        
        [self.recipeTableView reloadData];
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RecipeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RecipeCell" forIndexPath:indexPath];
    
    Recipe *recipe = self.filteredRecipes[indexPath.row];
    
    cell.recipe = recipe;
    
    [cell setRecipe];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.filteredRecipes.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 68;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    // 1. Dequeue the custom header cell
    RecipeTableViewCellHeaderCell *headerCell = [tableView dequeueReusableCellWithIdentifier:@"RecipeHeaderCell"];
    
    // 2. Set the various properties
    headerCell.titleLabel.text = @"Discover";
    [headerCell.titleLabel sizeToFit];

    return headerCell;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    if (searchText.length != 0) {

        NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(Recipe *evaluatedObject, NSDictionary *bindings) {
            Recipe *recipe = evaluatedObject;
            return [recipe.name containsString:searchText];
        }];
        self.filteredRecipes = [self.recipes filteredArrayUsingPredicate:predicate];
        
        NSLog(@"%@", self.filteredRecipes);
    }
    else {
        self.filteredRecipes = self.recipes;
    }
    
    [self.recipeTableView reloadData];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    UINavigationController *navigationController = [segue destinationViewController];
    
    DetailViewController *detailController = (DetailViewController*)navigationController.topViewController;
    
    UITableViewCell *tappedCell = sender;
    
    NSIndexPath *indexPath = [self.recipeTableView indexPathForCell:tappedCell];
    
    Recipe *recipe = self.recipes[indexPath.row];
    
    detailController.recipe = recipe;
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
