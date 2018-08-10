//
//  RecipeResultsViewController.m
//  Feast-fbu
//
//  Created by Jessica Shu on 8/3/18.
//  Copyright © 2018 jessjessandtre. All rights reserved.
//

#import "RecipeResultsViewController.h"
#import "RecipeTableViewCell.h"
#import <Parse/Parse.h>
#import "SVProgressHUD.h"
#import "RecipeDetailViewController.h"
#import "Tag.h"
#import "Saved.h"

@interface RecipeResultsViewController () <UITableViewDelegate, UITableViewDataSource, MGSwipeTableCellDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray* recipes;

@end

@implementation RecipeResultsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView setShowsVerticalScrollIndicator:NO];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveNotification:)
                                                 name:@"RecipeSaveNotification"
                                               object:nil];
    
    // Do any additional setup after loading the view.
    NSLog(@"coursetype %@", self.courseType );
    NSLog(@"tagname %@", self.tagName);
    NSLog(@"searchstring %@", self.searchString);
    [SVProgressHUD show];
    [self fetchRecipes];
}

- (void) receiveNotification: (NSNotification *) notification {
    if ([[notification name] isEqualToString:@"RecipeSaveNotification"]) {
        NSLog (@"Successfully received the recipe save notification results!");
        [self recipesWithCourseType];
    }
    //tag updates?
}
- (void) fetchRecipes {
    if (self.courseType){
        [self recipesWithCourseType];
    } else if (self.tagName){
        [self recipesWithTag];
    }
    else if (self.searchString) {
        [self recipesWithSearchString];
    }
}

- (void) recipesWithCourseType {
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
}

- (void) recipesWithTag {
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

- (void) recipesWithSearchString {
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

- (void) onSaveTapped:(id)sender {
    UIButton* saveButton = (UIButton*)sender;
    RecipeTableViewCell* cell = (RecipeTableViewCell*) [[[[[[sender superview] superview] superview] superview] superview] superview];
    Recipe* recipe = cell.recipe;
    if ([saveButton isSelected]){
        [Saved deleteSavedRecipe:recipe withCompletion:^(Boolean succeeded) {
            if (succeeded){
                [saveButton setSelected:NO];
                [[NSNotificationCenter defaultCenter]
                 postNotificationName:@"RecipeSaveNotification"
                 object:nil];
            }
        }];
        
    }
    
    else {
        [Saved saveRecipe:recipe withCompletion:^(Boolean succeeded) {
            if (succeeded){
                [saveButton setSelected:YES];
                [[NSNotificationCenter defaultCenter]
                 postNotificationName:@"RecipeSaveNotification"
                 object:nil];
            }
        }];
        
    }
    [cell hideSwipeAnimated:YES];
    
    //NSLog(@"%@", [[[[[[[sender superview] superview] superview] superview] superview] superview] class]);
    
}

-(void) onShareTapped:(id)sender{
    NSLog(@"share");
    RecipeTableViewCell* cell = (RecipeTableViewCell*) [[[[[[sender superview] superview] superview] superview] superview] superview];
    [cell hideSwipeAnimated:YES];
}



/**
 * Delegate method to setup the swipe buttons and swipe/expansion settings
 * Buttons can be any kind of UIView but it's recommended to use the convenience MGSwipeButton class
 * Setting up buttons with this delegate instead of using cell properties improves memory usage because buttons are only created in demand
 * @param cell the UITableViewCell to configure. You can get the indexPath using [tableView indexPathForCell:cell]
 * @param direction The swipe direction (left to right or right to left)
 * @param swipeSettings instance to configure the swipe transition and setting (optional)
 * @param expansionSettings instance to configure button expansions (optional)
 * @return Buttons array
 **/
-(nullable NSArray<UIView*>*) swipeTableCell:(nonnull MGSwipeTableCell*) cell swipeButtonsForDirection:(MGSwipeDirection)direction
                               swipeSettings:(nonnull MGSwipeSettings*) swipeSettings expansionSettings:(nonnull MGSwipeExpansionSettings*) expansionSettings {
    
    NSArray<UIView*>* arr = nil;
    if (direction == MGSwipeDirectionLeftToRight){
        //cell.backgroundColor = [UIColor grayColor];
        UIButton* save = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 100)];
        [save addTarget:self action:@selector(onSaveTapped:) forControlEvents:UIControlEventTouchUpInside];
        RecipeTableViewCell* recipeCell = (RecipeTableViewCell*)cell;
        
        [Saved savedRecipeExists:recipeCell.recipe withCompletion:^(Boolean saved) {
            if (saved){
                [save setSelected:YES];
            } else {
                [save setSelected:NO];
            }
        }];
        
        UIView* v1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 50)];
        [v1 setBackgroundColor:[UIColor whiteColor]];
        [v1.widthAnchor constraintEqualToConstant:30].active = true;
        [v1.heightAnchor constraintEqualToConstant:8].active = true;
        
        [save.widthAnchor constraintEqualToConstant:30].active = true;
        [save.heightAnchor constraintEqualToConstant:(recipeCell.recipeImageView.bounds.size.height)/2].active = true;
        UIImage *saveImage = [UIImage imageNamed:@"bookmark-outline.png"];
        [save setImage:saveImage forState:UIControlStateNormal];
        UIImage *saveImage2 = [UIImage imageNamed:@"bookmark.png"];
        [save setImage:saveImage2 forState:UIControlStateSelected];
        [save setBackgroundColor:[UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1.0]];
        save.layer.cornerRadius = save.frame.size.width / 16;
        
        
        UIButton* share = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        [share.widthAnchor constraintEqualToConstant:30].active = true;
        [share.heightAnchor constraintEqualToConstant:(recipeCell.recipeImageView.bounds.size.height)/2].active = true;;
        UIImage *shareImage = [UIImage imageNamed:@"share.png"];
        [share setImage:shareImage forState:UIControlStateNormal];
        [share setBackgroundColor:[UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1.0]];
        [share addTarget:self action:@selector(onShareTapped:) forControlEvents:UIControlEventTouchUpInside];
        share.layer.cornerRadius = share.frame.size.width / 16;
        
        
        UIView* v2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 50)];
        [v2 setBackgroundColor:[UIColor whiteColor]];
        [v2.widthAnchor constraintEqualToConstant:30].active = true;
        [v2.heightAnchor constraintEqualToConstant:recipeCell.recipeTitleLabel.bounds.size.height + 24].active = true;
        
        UIStackView* stackView = [[UIStackView alloc] initWithArrangedSubviews:@[v1,save,share, v2] ];
        stackView.frame = CGRectMake(0, 0, 80, 80);
        stackView.axis = UILayoutConstraintAxisVertical;
        stackView.distribution = UIStackViewDistributionEqualSpacing;
        stackView.spacing = 0;
        save.layer.zPosition = 1;
        
        
        cell.leftButtons = @[stackView];
        cell.leftSwipeSettings.transition = MGSwipeTransitionStatic;
        
        arr = @[stackView];
        
    }
    
    return arr;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RecipeTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"RecipeResultsTableViewCell" forIndexPath:indexPath];
    cell.recipeImageView.image = nil;
    cell.recipe = self.recipes[indexPath.row];
    [cell setRecipe];
    cell.delegate = self;
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
        RecipeTableViewCell* cell = (RecipeTableViewCell*)sender;
        recipeDetail.recipe = cell.recipe;
    }
}


@end
