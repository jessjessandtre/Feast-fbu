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
#import "TagCollectionViewCell.h"

@interface SearchViewController () <UITableViewDelegate, UITableViewDataSource, UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) NSArray *courseTypes;
@property (strong, nonatomic) IBOutlet UITableView *tableview;
@property (strong, nonatomic) IBOutlet UITableView *search;
@property (strong, nonatomic) IBOutlet UITextField *searchTextField;
@property (strong, nonatomic) IBOutlet UIButton *searchButton;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    CourseType *mainDish = [[CourseType alloc ] init];
    mainDish.name = @"Main";
    mainDish.image = [UIImage imageNamed:@"main"];
    
    CourseType *appetizer = [[CourseType alloc] init];
    appetizer.name = @"Appetizer";
    mainDish.image = [UIImage imageNamed:@"appetizer"];
    
    CourseType *salad = [[CourseType alloc] init];
    salad.name = @"Salad";
    salad.image = [UIImage imageNamed:@"salad"];
    
    CourseType *dessert = [[CourseType alloc] init];
    dessert.name = @"Dessert";
    dessert.image = [UIImage imageNamed:@"dessert"];
    
    CourseType *snack = [[CourseType alloc] init];
    snack.name = @"Snack";
    snack.image = [UIImage imageNamed:@"snack"];
    
    CourseType *drink = [[CourseType alloc] init];
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

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TagCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TagCollectionViewCell" forIndexPath:indexPath];
    
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 1;
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
