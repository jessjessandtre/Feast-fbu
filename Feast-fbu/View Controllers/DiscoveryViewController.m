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
#import "RecipeDetailViewController.h"
#import "DetailedPostViewController.h"
#import "RecipeTableViewCellHeaderCell.h"
#import <SVProgressHUD.h>
#import "CreatePostViewController.h"
#import "Saved.h"
#import "Post.h"
#import "ParseUI.h"
#import "PostCollectionViewCell.h"
#import "Tag.h"
#import "AutofillResultCellTableViewCell.h"

@interface DiscoveryViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate,  MGSwipeTableCellDelegate, UICollectionViewDataSource, UICollectionViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *recipeTableView;
@property (strong, nonatomic) NSArray *recipes;
@property (strong, nonatomic) NSArray *filteredRecipes;
@property (nonatomic, strong) NSArray *friendsPosts;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet UICollectionView *friendsCollectionView;
@property (strong, nonatomic) NSMutableArray *tags;
@property (strong, nonatomic) NSMutableArray *autocompleteTags;
@property (strong, nonatomic) UITableView *autocompleteTableView;
@property (assign, nonatomic) BOOL *moreDataLoading;

@end

@implementation DiscoveryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receivePostNotification:)
                                                 name:@"NewPostNotification"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(recipeSavedNotification:)
                                                 name:@"RecipeSaveNotification"
                                               object:nil];
    
    
    self.recipeTableView.delegate = self;
    self.recipeTableView.dataSource = self;
    self.friendsCollectionView.dataSource = self;
    self.friendsCollectionView.delegate = self;
    
    self.searchBar.delegate = self;
    
    self.recipeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.recipeTableView setShowsVerticalScrollIndicator:NO];
    [self.friendsCollectionView setShowsHorizontalScrollIndicator:NO];
    
    UICollectionViewFlowLayout *layout = self.friendsCollectionView.collectionViewLayout;
    
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 20;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
//    CGFloat postsPerLine = self.pos;
    
    [SVProgressHUD show];
    
    [self fetchFriendsPosts];
    [self fetchRecipes];
    // [self fetchTags];
    
    self.navigationItem.title = @"Discover";
    
    self.autocompleteTableView = [[UITableView alloc] initWithFrame:
                             CGRectMake(0, 80, 320, 120) style:UITableViewStylePlain];
    self.autocompleteTableView.delegate = self;
    self.autocompleteTableView.dataSource = self;
    self.autocompleteTableView.scrollEnabled = YES;
    self.autocompleteTableView.hidden = YES;
    
    self.tags = [NSMutableArray new];
    self.autocompleteTags = [NSMutableArray new];
    
    [self.view addSubview:self.autocompleteTableView];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchRecipes) forControlEvents:UIControlEventValueChanged];
    [self.recipeTableView insertSubview:self.refreshControl atIndex:0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) receivePostNotification: (NSNotification *) notification {
    if ([[notification name] isEqualToString:@"NewPostNotification"]) {
        NSLog (@"Successfully received the post notification!");
        [self fetchFriendsPosts];
    }
}

- (void) recipeSavedNotification: (NSNotification *) notification {
    if ([[notification name] isEqualToString:@"RecipeSaveNotification"]) {
        NSLog (@"Successfully received the recipe save notification!");
        [self.recipeTableView reloadData];
    }
}

- (void)fetchFriendsPosts {
    PFQuery *postQuery = [Post query];
    [postQuery includeKey:@"user"];
    [postQuery includeKey:@"recipe"];
    [postQuery includeKey:@"createdAt"];
    [postQuery orderByDescending:@"createdAt"];
    postQuery.limit = 20;
    
    [postQuery findObjectsInBackgroundWithBlock:^(NSArray<Post *> * _Nullable posts, NSError * _Nullable error) {
        [SVProgressHUD dismiss];
        if (posts) {
            self.friendsPosts = posts;
            
            [self.friendsCollectionView reloadData];
            NSLog(@"%@", posts);
        }
        else {
            NSLog(@"%@", error.localizedDescription);
        }
        
        [self.friendsCollectionView reloadData];
    }];
}

- (nonnull UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PostCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PostCollectionViewCell" forIndexPath:indexPath];
    
    Post *post = self.friendsPosts[indexPath.row];
    
    cell.post = post;
    return cell;
    
}

- (NSInteger)collectionView:(nonnull UICollectionView *)friendsCollectionView numberOfItemsInSection:(NSInteger)section {
    return self.friendsPosts.count;
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

- (void) fetchTags {
    PFQuery *tagQuery = [PFQuery queryWithClassName:@"Tag"];
    [tagQuery includeKey:@"name"];
    [tagQuery findObjectsInBackgroundWithBlock:^(NSArray<Tag *> * _Nullable tags, NSError * _Nullable error) {
        if (tags) {
            for (int i = 0; i < tags.count; i++) {
                Tag *tag = [Tag new];
                tag = tags[i];
                NSString *tagName = tag[@"name"];
                if (![self.tags containsObject:tagName]) {
                    [self.tags addObject:tagName];
                    NSLog(@"%@", self.tags);
                }
            }
        }
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // if (tableView == self.recipeTableView) {
        RecipeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RecipeCell" forIndexPath:indexPath];
        
        Recipe *recipe = self.filteredRecipes[indexPath.row];
        
        cell.recipe = recipe;
        
        cell.recipeImageView.image = nil;
        
        [cell setRecipe];
        
        if (![self.filteredRecipes isEqualToArray:self.recipes]) {
            cell.recipeTitleLabel.hidden = NO;
        }
        cell.delegate = self;
        
        return cell;
    // }
    /*
    else {
        static NSString *cellIdentifier = @"Cell";
        AutofillResultCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        cell.tagLabel = self.autocompleteTags[indexPath.row];
        return cell;
    }
     */
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
        RecipeTableViewCell* recipeCell = (RecipeTableViewCell*)cell;

        [Saved savedRecipeExists:recipeCell.recipe withCompletion:^(Boolean saved) {
            if (saved){
                [save setSelected:YES];
            } else {
                [save setSelected:NO];
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
    if (tableView == self.recipeTableView) {
        return self.filteredRecipes.count;
    }
    else {
        return self.autocompleteTags.count;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    // 1. Dequeue the custom header cell
    RecipeTableViewCellHeaderCell *headerCell = [tableView dequeueReusableCellWithIdentifier:@"RecipeHeaderCell"];
    
    // 2. Set the various properties
    headerCell.titleLabel.text = @"Discover Recipes";
    [headerCell.titleLabel sizeToFit];

    return headerCell;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    if (searchText.length != 0) {
        /*
        self.autocompleteTableView.hidden = NO;
        
        NSString *substring = [NSString stringWithString:searchText];
        substring = [substring lowercaseString];
        [self searchAutocompleteEntriesWithSubstring:substring];
        */

        NSPredicate *namePredicate = [NSPredicate predicateWithBlock:^BOOL(Recipe *evaluatedObject, NSDictionary *bindings) {
            Recipe *recipe = evaluatedObject;
            return [[recipe.name lowercaseString] containsString:[searchText lowercaseString]];
        }];
        /*
        NSArray *tagged;
        PFQuery* query = [PFQuery queryWithClassName:@"Tag"];
        [query includeKey:@"recipe"];
        [query whereKey:@"name" containsString:[searchText lowercaseString]];
        [query findObjectsInBackgroundWithBlock:^(NSArray<Tag *> * _Nullable tags, NSError * _Nullable error) {
            [tagged initWithArray:tags];
        }];
        NSPredicate *tagPredicate = [NSPredicate predicateWithBlock:^BOOL(Recipe *evaluatedObject, NSDictionary* bindings) {
            Recipe *recipe = evaluatedObject;
            recipe =
        }];
        */
        
        NSPredicate *tagPredicate = [NSPredicate predicateWithBlock:^BOOL(Recipe *evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
            Recipe *recipe = evaluatedObject;
            if ([recipe[@"tags"] containsObject:[searchText lowercaseString]]) {
                int index = [recipe[@"tags"] indexOfObject:[searchText lowercaseString]];
                return [recipe[@"tags"][index] containsString:[searchText lowercaseString]];
            }
            else {
                return [recipe[@"tags"] containsObject:[searchText lowercaseString]];
            }
        }];
        
        
        NSPredicate *combinedPredicate = [NSCompoundPredicate orPredicateWithSubpredicates:@[namePredicate, tagPredicate]];
        
        self.filteredRecipes = [self.recipes filteredArrayUsingPredicate:combinedPredicate];

        NSLog(@"%@", self.filteredRecipes);
    }
    else {
        self.filteredRecipes = self.recipes;
    }
    
    [self.recipeTableView reloadData];
    // self.autocompleteTableView.hidden = YES;
}

/*
- (void)searchAutocompleteEntriesWithSubstring:(NSString *)substring {
    
    // Put anything that starts with this substring into the autocompleteUrls array
    // The items in this array is what will show up in the table view
    [self.autocompleteTags removeAllObjects];
    for(NSString *curString in self.tags) {
        NSRange substringRange = [curString rangeOfString:substring];
        if (substringRange.location == 0) {
            [self.autocompleteTags addObject:curString];
        }
    }
    [self.autocompleteTableView reloadData];
}
 */

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
/*
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if(!self.moreDataLoading) {
        int scrollViewContentHeight = self.recipeTableView.contentSize.height;
        int scrollOffsetThreshold = scrollViewContentHeight - self.recipeTableView.bounds.size.height;
        
        
    }
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"DetailedRecipeSegue2"]){
        RecipeDetailViewController* detailViewController = [segue destinationViewController];
        
        UITableViewCell *tappedCell = sender;
        
        NSIndexPath *indexPath = [self.recipeTableView indexPathForCell:tappedCell];
        
        Recipe *recipe = self.recipes[indexPath.row];
        
        detailViewController.recipe = recipe;
    } else if ([segue.identifier isEqualToString:@"DetailedPostSegue"]){
        PostCollectionViewCell* cell = (PostCollectionViewCell*) sender;
        DetailedPostViewController* detailedPostViewController = [segue destinationViewController];
        detailedPostViewController.post = cell.post;
    
    }
}


@end
