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
    [SVProgressHUD show];
    [self fetchRecipes];
}

- (void) fetchRecipes {
    PFQuery* query = [PFQuery queryWithClassName:@"Recipe"];
    //[query whereKey:@"courseType" equalTo:self.courseType.name];
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
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RecipeResultsTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"RecipeResultsTableViewCell" forIndexPath:indexPath];
    cell.recipe = self.recipes[indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.recipes.count;
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
