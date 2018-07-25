//
//  SavedRecipesViewController.m
//  Feast-fbu
//
//  Created by Jessica Shu on 7/25/18.
//  Copyright © 2018 jessjessandtre. All rights reserved.
//

#import "SavedRecipesViewController.h"
#import "SVProgressHUD.h"
#import "SavedRecipesCollectionViewCell.h"
#import <Parse/Parse.h>
#import "DetailViewController.h"


@interface SavedRecipesViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;\
@property (strong, nonatomic) NSMutableArray* recipes;

@end

@implementation SavedRecipesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    
    CGFloat postsPerLine = 2;
    CGFloat itemWidth = (self.collectionView.frame.size.width -  layout.minimumInteritemSpacing * (postsPerLine - 1))/ postsPerLine;
    CGFloat itemHeight = itemWidth;
    layout.itemSize = CGSizeMake(itemWidth,itemHeight);
    
    [SVProgressHUD show];
    [self fetchSavedRecipes];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) fetchSavedRecipes {
    PFQuery* query = [PFQuery queryWithClassName:@"Saved"];
    [query orderByDescending:@"createdAt"];
    [query whereKey:@"user" equalTo:[PFUser currentUser]];
    [query includeKey:@"savedRecipe"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        [SVProgressHUD dismiss];
        if (objects){
            NSLog(@"fetched saved recipes successfully");
            self.recipes = [[NSMutableArray alloc] init];
            for (PFObject* obj in objects){
                Recipe* recipe = (Recipe*)[obj objectForKey:@"savedRecipe"];
                [self.recipes addObject:recipe];
            }
            //NSLog(@"%@", self.recipes);
            [self.collectionView reloadData];
        }
        else {
            NSLog(@"error fetching saved recipes: %@", error.localizedDescription);
        }
    }];
    
    
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    SavedRecipesCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SavedRecipesCollectionViewCell" forIndexPath:indexPath];
    Recipe* recipe = self.recipes[indexPath.item];
    cell.recipe = recipe;

    return cell;
    
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.recipes.count;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"DetailedRecipeSegue3"]){
        DetailViewController* detailedRecipeViewController = [segue destinationViewController];
        SavedRecipesCollectionViewCell* cell = (SavedRecipesCollectionViewCell*)sender;
        detailedRecipeViewController.recipe = cell.recipe;
    }
}


@end
