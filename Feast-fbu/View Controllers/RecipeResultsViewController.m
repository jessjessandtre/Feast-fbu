//
//  RecipeResultsViewController.m
//  Feast-fbu
//
//  Created by Jessica Shu on 8/3/18.
//  Copyright © 2018 jessjessandtre. All rights reserved.
//

#import "RecipeResultsViewController.h"
#import "RecipeResultsTableViewCell.h"

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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
