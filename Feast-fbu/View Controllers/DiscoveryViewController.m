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
    /*
    MGSwipeButton* save = [MGSwipeButton buttonWithTitle:@"save" backgroundColor:[UIColor greenColor] insets: UIEdgeInsetsMake(0, 0, 0, 0) callback:^BOOL(MGSwipeTableCell * _Nonnull cell) {
        NSLog(@"save");
        return YES;
    }];
    
    MGSwipeButton* share = [MGSwipeButton buttonWithTitle:@"share" backgroundColor:[UIColor blueColor] insets: UIEdgeInsetsMake(0, 0, 0, 0) callback:^BOOL(MGSwipeTableCell * _Nonnull cell) {
        NSLog(@"share");
        return YES;
    }];
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 70, 70) ];
    view.backgroundColor = [UIColor purpleColor];
    [view addSubview:save];
    [view addSubview:share];
    
    
    cell.leftButtons = @[view];
  */
    UIButton* save = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    save.backgroundColor = [UIColor blackColor];
    save.titleLabel.text = @"save";
    [save addTarget:self action:@selector(onSave:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton* share = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    share.backgroundColor = [UIColor redColor];
    share.titleLabel.text = @"share";
    [share addTarget:self action:@selector(onShare) forControlEvents:UIControlEventTouchUpInside];
    
    UIStackView* stackView = [[UIStackView alloc] initWithArrangedSubviews:@[save,share] ];
    stackView.frame = CGRectMake(0, 0, 80, 80);
    stackView.axis = UILayoutConstraintAxisVertical;
    stackView.distribution = UIStackViewDistributionFillEqually;
    save.layer.zPosition = 1;
    cell.leftButtons = @[stackView];
    cell.leftSwipeSettings.transition = MGSwipeTransitionStatic;
    return cell;
}
- (void) onSave:(id)sender {
    NSLog(@"save");
    //NSLog(@"%@", [[[[[[[sender superview] superview] superview] superview] superview] superview] class]);
    RecipeTableViewCell* cell = (RecipeTableViewCell*) [[[[[[sender superview] superview] superview] superview] superview] superview];
    
    Saved* saved = [Saved new];
    [saved setObject:[PFUser currentUser] forKey:@"user"];
    [saved setObject:cell.recipe forKey:@"savedRecipe"];
    [saved saveEventually];
    
}

-(void) onShare {
    NSLog(@"share");
}

-(BOOL) swipeTableCell:(nonnull MGSwipeTableCell *)cell shouldHideSwipeOnTap:(CGPoint) point {
    return YES;
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
