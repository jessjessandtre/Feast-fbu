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
#import "RecipeResultsViewController.h"

@interface SearchViewController () <UITableViewDelegate, UITableViewDataSource, UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) NSArray *courseTypes;
@property (strong, nonatomic) IBOutlet UITableView *searchTableView;
@property (strong, nonatomic) IBOutlet UITextField *searchTextField;
@property (strong, nonatomic) IBOutlet UIButton *searchButton;
@property (strong, nonatomic) IBOutlet UICollectionView *tagCollectionView;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.searchTableView.delegate = self;
    self.searchTableView.dataSource = self;
    self.tagCollectionView.delegate = self;
    self.tagCollectionView.dataSource = self;
    
    CourseType *mainDish = [[CourseType alloc ] init];
    mainDish.name = @"main";
    mainDish.image = [UIImage imageNamed:@"main"];
    
    CourseType *appetizer = [[CourseType alloc] init];
    appetizer.name = @"appetizer";
    appetizer.image = [UIImage imageNamed:@"appetizer"];
    
    CourseType *salad = [[CourseType alloc] init];
    salad.name = @"salad";
    salad.image = [UIImage imageNamed:@"salad"];
    
    CourseType *dessert = [[CourseType alloc] init];
    dessert.name = @"dessert";
    dessert.image = [UIImage imageNamed:@"dessert"];
    
    CourseType *snack = [[CourseType alloc] init];
    snack.name = @"snack";
    snack.image = [UIImage imageNamed:@"snack"];
    
    CourseType *drink = [[CourseType alloc] init];
    drink.name = @"drink";
    drink.image = [UIImage imageNamed:@"drink"];
    
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


 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
     if ([segue.identifier isEqualToString:@"RecipeResultsSegue"]){
         RecipeResultsViewController* recipeResults = [segue destinationViewController];
         CourseTypeTableViewCell* cell = (CourseTypeTableViewCell*)sender;
         recipeResults.courseType = cell.courseType;
     }
 }



@end
