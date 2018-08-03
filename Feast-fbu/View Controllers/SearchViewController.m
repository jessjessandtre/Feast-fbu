//
//  SearchViewController.m
//  Feast-fbu
//
//  Created by Jessica Au on 8/3/18.
//  Copyright © 2018 jessjessandtre. All rights reserved.
//

#import "SearchViewController.h"
#import "CourseType.h"
#import "CourseTypeTableViewCell.h"

@interface SearchViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray *courseTypes;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CourseType *mainDish = [CourseType new];
    mainDish.name = @"Main";
    mainDish.image = [UIImage imageNamed:@"main"];
    
    CourseType *appetizer = [CourseType new];
    appetizer.name = @"Appetizer";
    mainDish.image = [UIImage imageNamed:@"appetizer"];
    
    CourseType *salad = [CourseType new];
    salad.name = @"Salad";
    salad.image = [UIImage imageNamed:@"salad"];
    
    CourseType *dessert = [CourseType new];
    dessert.name = @"Dessert";
    dessert.image = [UIImage imageNamed:@"dessert"];
    
    CourseType *snack = [CourseType new];
    snack.name = @"Snack";
    snack.image = [UIImage imageNamed:@"snack"];
    
    CourseType *drink = [CourseType new];
    drink.name = @"Drink";
    drink.image = [UIImage imageNamed:@"snack"];
    
    self.courseTypes = @[mainDish, appetizer, salad, dessert, snack, drink];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CourseTypeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CourseTypeCell" forIndexPath:indexPath];
    CourseType *courseType = self.courseTypes[indexPath.row];
    cell.courseType = courseType;
    [cell setCourseType];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.courseTypes.count;
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
