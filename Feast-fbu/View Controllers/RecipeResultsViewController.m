//
//  RecipeResultsViewController.m
//  Feast-fbu
//
//  Created by Jessica Shu on 8/3/18.
//  Copyright © 2018 jessjessandtre. All rights reserved.
//

#import "RecipeResultsViewController.h"
#import "RecipeResultsTableViewCell.h"
#import <Parse/Parse.h>
#import "SVProgressHUD.h"
#import "RecipeDetailViewController.h"
#import "Tag.h"

@interface RecipeResultsViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray* recipes;

@end

@implementation RecipeResultsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    // Do any additional setup after loading the view.
    NSLog(@"coursetype %@", self.courseType );
    NSLog(@"tagname %@", self.tagName);
    NSLog(@"searchstring %@", self.searchString);
    [SVProgressHUD show];
    [self fetchRecipes];
}

- (void) fetchRecipes {
    if (self.courseType){
        PFQuery* query = [PFQuery queryWithClassName:@"Recipe"];
        [query whereKey:@"courseType" equalTo:self.courseType.name];
        query.limit = 20;
        
        [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
            [SVProgressHUD dismiss];
            if (objects){
                self.recipes = objects;
                [self.tableView reloadData];
            }
            else {
                NSLog(@"error finding recipe results: %@", error.localizedDescription);
            }
        }];
    } else if (self.tagName){
        PFQuery* tagQuery = [PFQuery queryWithClassName:@"Tag"];
        [tagQuery whereKey:@"name" equalTo:self.tagName];
        [tagQuery includeKey:@"recipe"];
        tagQuery.limit = 20;
        
        [tagQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
            [SVProgressHUD dismiss];
            if (objects){
                NSMutableArray* arr = [[NSMutableArray alloc]init];
                for (Tag* tag in objects){
                    [arr addObject:tag.recipe];
                }
                self.recipes = [NSArray arrayWithArray:arr];
                [self.tableView reloadData];
            }else {
                NSLog(@"error finding recipe results: %@", error.localizedDescription);
            }
        }];
    }
    else if (self.searchString) {
        PFQuery *searchQuery = [PFQuery queryWithClassName:@"Recipe"];
        [searchQuery whereKey:@"name" containsString:self.searchString];
        searchQuery.limit = 20;
        
        [searchQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
            [SVProgressHUD dismiss];
            if (objects){
                self.recipes = objects;
                [self.tableView reloadData];
            }
            else {
                NSLog(@"error finding recipe results: %@", error.localizedDescription);
            }
        }];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RecipeResultsTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"RecipeResultsTableViewCell" forIndexPath:indexPath];
    cell.recipe = self.recipes[indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.recipes.count;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"DetailedRecipeSegue4"]){
        RecipeDetailViewController* recipeDetail = [segue destinationViewController];
        RecipeResultsTableViewCell* cell = (RecipeResultsTableViewCell*)sender;
        recipeDetail.recipe = cell.recipe;
    }
}


@end
