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
#import <SVProgressHUD.h>
#import "CreatePostViewController.h"
#import "Saved.h"

@interface DiscoveryViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, PostUpdateDelegate, MGSwipeTableCellDelegate>

@property (strong, nonatomic) IBOutlet UITableView *recipeTableView;
@property (strong, nonatomic) NSArray *recipes;
@property (strong, nonatomic) NSArray *filteredRecipes;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) UIRefreshControl *refreshControl;



@end

@implementation DiscoveryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.recipeTableView.delegate = self;
    self.recipeTableView.dataSource = self;
    self.searchBar.delegate = self;
    
    self.recipeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [SVProgressHUD show];
    
    [self fetchRecipes];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchRecipes) forControlEvents:UIControlEventValueChanged];
    [self.recipeTableView insertSubview:self.refreshControl atIndex:0];
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
        [SVProgressHUD dismiss];
        if (recipes) {
            self.recipes = recipes;
            self.filteredRecipes = self.recipes;
            [self.recipeTableView reloadData];
        }
        else {
            NSLog(@"%@", error.localizedDescription);
            [self alertControlWithTitle:@"Error fetching data" andMessage:error.localizedDescription];
        }
        
        [self.recipeTableView reloadData];
        [self.refreshControl endRefreshing];
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RecipeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RecipeCell" forIndexPath:indexPath];
    
    Recipe *recipe = self.filteredRecipes[indexPath.row];
    
    cell.recipe = recipe;
    
    [cell setRecipe];
    
    if (![self.filteredRecipes isEqualToArray:self.recipes]) {
        cell.recipeTitleLabel.hidden = NO;
    }
    cell.delegate = self;
    return cell;
    
}
- (void) onSaveTapped:(id)sender {
    UIButton* saveButton = (UIButton*)sender;
    RecipeTableViewCell* cell = (RecipeTableViewCell*) [[[[[[sender superview] superview] superview] superview] superview] superview];
    Recipe* recipe = cell.recipe;
    if ([saveButton isSelected]){
        PFQuery* query = [PFQuery queryWithClassName:@"Saved"];
        [query whereKey:@"user" equalTo:[PFUser currentUser]];
        [query whereKey:@"savedRecipe" equalTo:recipe];
        
        [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
            if (!error){
                Saved* saved = (Saved*) objects[0];
                [saved deleteInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                    if (succeeded){
                        NSLog(@"deleted save object");
                        [saveButton setSelected:false];
                    }
                    else {
                        NSLog(@"error deleting save object: %@", error.localizedDescription);
                    }
                }];
            }
            else {
                NSLog(@"error retreiving saved object: %@", error.localizedDescription);
            }
        }];
        
    }
    
    else {
        Saved* saved = [Saved new];
        [saved setObject:[PFUser currentUser] forKey:@"user"];
        [saved setObject:recipe forKey:@"savedRecipe"];
        [saved saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if (succeeded){
                NSLog(@"saved recipe");
                [saveButton setSelected:true];
            }
            else {
                NSLog(@"error saving recipe: %@" , error.localizedDescription);
            }
        }];
         
    }
    [cell hideSwipeAnimated:YES];
    //NSLog(@"%@", [[[[[[[sender superview] superview] superview] superview] superview] superview] class]);

}

-(void) onShareTapped:(id)sender{
    NSLog(@"share");
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
        UIButton* save = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        [save addTarget:self action:@selector(onSaveTapped:) forControlEvents:UIControlEventTouchUpInside];
        PFQuery *saveQuery = [PFQuery queryWithClassName:@"Saved"];
        [saveQuery whereKey:@"user" equalTo:[PFUser currentUser]];
        RecipeTableViewCell* recipeCell = (RecipeTableViewCell*)cell;
        [saveQuery whereKey:@"savedRecipe" equalTo:recipeCell.recipe];
        [saveQuery countObjectsInBackgroundWithBlock:^(int number, NSError * _Nullable error) {
            if (!error){
                if (number == 1){
                    [save setSelected:YES];
                }
                else {
                    [save setSelected:NO];
                }
            }
            else {
                NSLog(@"error counting number of saved recipes: %@", error.localizedDescription);
            }
        }];
        [save setTitle:@"save" forState:UIControlStateNormal];
        [save setTitle:@"saved" forState:UIControlStateSelected];
        [save setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [save setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        
        UIButton* share = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        [share setTitle:@"share" forState:UIControlStateNormal];
        [share setTitle:@"unshare" forState:UIControlStateSelected];
        [share setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [share setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        [share addTarget:self action:@selector(onShareTapped:) forControlEvents:UIControlEventTouchUpInside];
        
        UIStackView* stackView = [[UIStackView alloc] initWithArrangedSubviews:@[save,share] ];
        stackView.frame = CGRectMake(0, 0, 80, 80);
        stackView.axis = UILayoutConstraintAxisVertical;
        stackView.distribution = UIStackViewDistributionFillEqually;
        save.layer.zPosition = 1;
        
        
        cell.leftButtons = @[stackView];
        cell.leftSwipeSettings.transition = MGSwipeTransitionStatic;
        
        arr = @[stackView];

    }
    return arr;
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
            return [[recipe.name lowercaseString] containsString:[searchText lowercaseString]];
        }];
        self.filteredRecipes = [self.recipes filteredArrayUsingPredicate:predicate];
        
        NSLog(@"%@", self.filteredRecipes);
    }
    else {
        self.filteredRecipes = self.recipes;
    }
    
    [self.recipeTableView reloadData];
}

- (void) didCreatePost {
    [self fetchRecipes];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.recipeTableView scrollToRowAtIndexPath:indexPath
                         atScrollPosition:UITableViewScrollPositionTop
                                 animated:YES];
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
    
    if ([segue.identifier isEqualToString:@"DetailedRecipeSegue2"]){
        DetailViewController* detailController = [segue destinationViewController];
        UITableViewCell *tappedCell = sender;
        
        NSIndexPath *indexPath = [self.recipeTableView indexPathForCell:tappedCell];
        
        Recipe *recipe = self.recipes[indexPath.row];
        
        detailController.recipe = recipe;
    }
        
    
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
