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
#import "Follow.h"
#import "InfiniteScrollActivityView.h"

@interface DiscoveryViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate,  MGSwipeTableCellDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UITabBarDelegate>

@property (strong, nonatomic) IBOutlet UITableView *recipeTableView;
@property (strong, nonatomic) NSMutableArray *recipes;
@property (nonatomic, strong) NSArray *friendsPosts;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet UICollectionView *friendsCollectionView;
@property (assign, nonatomic) BOOL dataIsLoading;
@property InfiniteScrollActivityView *loadingMoreView;


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
    
    self.tabBarController.delegate = self;
    
    //self.searchBar.delegate = self;
    
    self.recipeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.recipeTableView setShowsVerticalScrollIndicator:NO];
    [self.friendsCollectionView setShowsHorizontalScrollIndicator:NO];
    
    UICollectionViewFlowLayout *layout =(UICollectionViewFlowLayout *) self.friendsCollectionView.collectionViewLayout;
    
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 20;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    // Setting up Infinite Scroll loading indicator
    CGRect frame = CGRectMake(0, self.recipeTableView.contentSize.height, self.recipeTableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight);
    self.loadingMoreView = [[InfiniteScrollActivityView alloc] initWithFrame:frame];
    self.loadingMoreView.hidden = true;
    [self.recipeTableView addSubview:self.loadingMoreView];
    
    UIEdgeInsets insets = self.recipeTableView.contentInset;
    insets.bottom += InfiniteScrollActivityView.defaultHeight;
    self.recipeTableView.contentInset = insets;
    
    [SVProgressHUD show];
    
    [self fetchFriendsPosts];
    [self fetchRecipes];
    // [self fetchTags];
    
    self.navigationItem.title = @"Discover";
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchRecipes) forControlEvents:UIControlEventValueChanged];
    [self.recipeTableView insertSubview:self.refreshControl atIndex:0];
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
    PFQuery *followerQuery = [Follow query];
    [followerQuery includeKey:@"toUser"];
    [followerQuery whereKey:@"fromUser" equalTo:[PFUser currentUser]];
    
    PFQuery *postQuery = [Post query];
    [postQuery includeKey:@"user"];
    [postQuery includeKey:@"recipe"];
    [postQuery includeKey:@"createdAt"];
    [postQuery orderByDescending:@"createdAt"];
    [postQuery whereKey:@"user" matchesKey:@"toUser" inQuery:followerQuery];
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
            self.recipes = [NSMutableArray arrayWithArray:recipes];
            [self.recipeTableView reloadData];
        }
        else {
            NSLog(@"%@", error.localizedDescription);
            [self alertControlWithTitle:@"Error fetching data" andMessage:error.localizedDescription];
        }
        
        [self.recipeTableView reloadData];
        [self.refreshControl endRefreshing];
        
        NSLog(@"%@", self.recipes[0][@"courseType"]);
    }];
}

- (void) fetchMoreRecipes {
    
    Recipe *lastRecipe = [self.recipes objectAtIndex:self.recipes.count - 1];
    NSMutableArray *newIndexPaths = [NSMutableArray array];
    
    PFQuery *recipeQuery = [Recipe query];
    [recipeQuery orderByDescending:@"createdAt"];
    [recipeQuery whereKey:@"createdAt" lessThan:lastRecipe.createdAt];
    recipeQuery.limit = 5;
    
    [recipeQuery findObjectsInBackgroundWithBlock:^(NSArray<Recipe *> * _Nullable recipes, NSError * _Nullable error) {
        if (recipes) {
            for (Recipe *i in recipes) {
                [self.recipes addObject:i];
                
                NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:self.recipes.count-1 inSection:0];
                [newIndexPaths addObject:newIndexPath];
            }
            [self.loadingMoreView stopAnimating];
            
            [self.recipeTableView performBatchUpdates:^{
                [self.recipeTableView insertRowsAtIndexPaths:newIndexPaths withRowAnimation:UITableViewRowAnimationNone];
            } completion:^(BOOL finished) {
                if (finished) {
                    self.dataIsLoading = NO;
                }
            }];
        }
        else {
            NSLog(@"%@", error.localizedDescription);
            [self alertControlWithTitle:@"Error fetching data" andMessage:error.localizedDescription];
        }
        
        [self.recipeTableView reloadData];
        [self.refreshControl endRefreshing];
        
        NSLog(@"%@", self.recipes[0][@"courseType"]);
    }];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
        RecipeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RecipeCell" forIndexPath:indexPath];
        Recipe *recipe = self.recipes[indexPath.row];
        cell.recipe = recipe;
        cell.recipeImageView.image = nil;
        [cell setRecipe];
        cell.delegate = self;
        return cell;
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
    return self.recipes.count;
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
    headerCell.titleLabel.text = @"Recipes For You";
    [headerCell.titleLabel sizeToFit];

    return headerCell;
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if(!self.dataIsLoading) {
        int scrollViewContentHeight = self.recipeTableView.contentSize.height;
        int scrollOffsetThreshold = scrollViewContentHeight - self.recipeTableView.bounds.size.height;
        
        if (scrollView.contentOffset.y > scrollOffsetThreshold && self.recipeTableView.isDragging) {
            self.dataIsLoading = true;
            NSLog(@"Data is loading");
            
            CGRect frame = CGRectMake(0, self.recipeTableView.contentSize.height, self.recipeTableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight);
            
            self.loadingMoreView.frame = frame;
            [self.loadingMoreView startAnimating];
            
            [self fetchMoreRecipes];
        }
    }
}


- (void)tabBarController:(UITabBarController *)tabBarController
didSelectViewController:(UIViewController *)viewController
{
    static UIViewController *previousController = nil;
    if (previousController == viewController) {
        // the same tab was tapped a second time
        [self.recipeTableView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    previousController = viewController;
}


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
