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
#import "SVProgressHUD.h"
#import <Parse/Parse.h>
#import "Tag.h"

@interface SearchViewController () <UITableViewDelegate, UITableViewDataSource, UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) NSArray *courseTypes;
@property (strong, nonatomic) IBOutlet UITableView *searchTableView;
@property (strong, nonatomic) IBOutlet UITextField *searchTextField;
@property (strong, nonatomic) IBOutlet UIButton *searchButton;
@property (strong, nonatomic) IBOutlet UICollectionView *tagCollectionView;
@property (strong, nonatomic) NSMutableDictionary<NSString*, NSNumber*>* tagDictionary;
@property (strong, nonatomic) NSArray<NSString*>* orderedTagNamesArray;

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
    
    [SVProgressHUD show];
    [self getTags];
}

- (void) getTags {
    PFQuery* query = [PFQuery queryWithClassName:@"Tag"];
    self.tagDictionary = [[NSMutableDictionary alloc] init];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        [SVProgressHUD dismiss];
        if (objects) {
            NSLog(@"objects %@", objects);
            for (Tag* tag in objects){
                if ([self.tagDictionary objectForKey:tag.name]){
                    NSInteger num = [[self.tagDictionary objectForKey:tag.name] integerValue];
                    num += 1;
                    [self.tagDictionary setObject:[NSNumber numberWithInt:num] forKey:tag.name];
                }
                else {
                    [self.tagDictionary setObject:[NSNumber numberWithInt:1] forKey:tag.name];
                }
            }
            NSLog(@" dictionary %@",self.tagDictionary);
            self.orderedTagNamesArray = [self.tagDictionary keysSortedByValueUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                NSNumber* left = (NSNumber*)obj1;
                NSNumber* right = (NSNumber*)obj2;
                if (left < right){
                    return NSOrderedDescending;
                }
                else if (right > left){
                    return NSOrderedAscending;
                }
                else {
                    return NSOrderedSame;
                }
            }];
            NSLog(@"tag array: %@", self.orderedTagNamesArray);
        }
        else {
            NSLog(@"error getting tags: %@", error.localizedDescription);
        }
    }];
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
    cell.tagName = self.orderedTagNamesArray[indexPath.row];
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.orderedTagNamesArray.count;
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
