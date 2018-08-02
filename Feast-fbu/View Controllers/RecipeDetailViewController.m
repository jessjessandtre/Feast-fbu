//
//  RecipeDetailViewController.m
//  Feast-fbu
//
//  Created by Jessica Au on 7/27/18.
//  Copyright © 2018 jessjessandtre. All rights reserved.
//

#import "UIImageView+AFNetworking.h"
#import "RecipeDetailViewController.h"
#import "DetailRecipeTableViewCell.h"
#import "Saved.h"
#import "Post.h"
#import "CreatePostViewController.h"
#import "PostCollectionViewCell.h"
#import "DetailedPostViewController.h"

@interface RecipeDetailViewController () <UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *recipeTableView;
@property (weak, nonatomic) IBOutlet UICollectionView *postCollectionView;
@property (strong, nonatomic) NSArray *posts;

@end

@implementation RecipeDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.recipeTableView.delegate = self;
    self.recipeTableView.dataSource = self;
    self.postCollectionView.delegate = self;
    self.postCollectionView.dataSource = self;
    
    self.navigationItem.title = self.recipe.name; 
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(recipeSavedNotification:)
                                                 name:@"RecipeSaveNotification"
                                               object:nil];
    
    UICollectionViewFlowLayout *collectionViewLayout = self.postCollectionView.collectionViewLayout;
    
    collectionViewLayout.minimumInteritemSpacing = 0;
    collectionViewLayout.minimumLineSpacing = 2;
    collectionViewLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    [self fetchPosts];
}

- (void) fetchPosts {
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    [query orderByDescending:@"createdAt"];
    [query includeKey:@"recipe"];
    [query includeKey:@"user"];
    [query whereKey:@"recipe" equalTo:self.recipe];
    
    query.limit = 20;
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError * _Nullable error) {
        if (posts != nil) {
            self.posts = posts;
            NSLog(@"%@", posts);
            [self.postCollectionView reloadData];
        } else {
            NSLog(@"Error%@", error.localizedDescription);
        }
    }];
}

- (void) recipeSavedNotification: (NSNotification *) notification {
    if ([[notification name] isEqualToString:@"RecipeSaveNotification"]) {
        NSLog (@"Successfully received the recipe save notification!");
        DetailRecipeTableViewCell* cell = [self.recipeTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        [cell updateSaveButton];
    }
}



- (IBAction)saveButtonTapped:(id)sender {
    UIButton* saveButton = (UIButton*)sender;
    if ([saveButton isSelected]){
        [Saved deleteSavedRecipe:self.recipe withCompletion:^(Boolean succeeded) {
            if (succeeded){
                [saveButton setSelected:NO];
                [[NSNotificationCenter defaultCenter]
                 postNotificationName:@"RecipeSaveNotification"
                 object:nil];
            }
        }];
        
    }
    
    else {
        [Saved saveRecipe:self.recipe withCompletion:^(Boolean succeeded) {
            if (succeeded){
                [saveButton setSelected:YES];
                [[NSNotificationCenter defaultCenter]
                 postNotificationName:@"RecipeSaveNotification"
                 object:nil];
            }
        }];
        
    }
}

- (IBAction)postButtonTapped:(id)sender {
    [self createImagePickerController];
}

- (void)createImagePickerController {
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    //imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    if ([UIImagePickerController isSourceTypeAvailable:(UIImagePickerControllerSourceTypeCamera)]){
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else {
        NSLog(@"Camera 🚫 available so we will use photo library instead");
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(nonnull NSDictionary<NSString *,id> *)info {
    // Get thew image captured by the UIImagePickerController
    //  UIImage *originalImage = info[UIImagePickerControllerOriginalImage];
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    
    // Do something with the images (based on your use case)
    
    // Dismess UIImagePickerController to go back to your original view controller
    [self dismissViewControllerAnimated:YES completion:^(){
        [self performSegueWithIdentifier:@"CreatePostSegue" sender:editedImage];
    }];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DetailRecipeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RecipeCell"];
    Recipe *recipe = self.recipe;
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.recipe = recipe;
    [cell setRecipe];
    return cell;
}
    
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
     PostCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PostCollectionViewCell" forIndexPath:indexPath];
    Post *post = self.posts[indexPath.item];
    cell.post = post;
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.posts.count;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqual:@"CreatePostSegue"]){
        UIImage *image = sender;
        UINavigationController *navigationController =[segue destinationViewController];
        CreatePostViewController *createPostViewController = (CreatePostViewController*) navigationController.topViewController;
        
        createPostViewController.image = image;
        createPostViewController.recipe = self.recipe;
        // createPostViewController.intermediateDelegate = self;
    } else if ([segue.identifier isEqualToString:@"DetailedPostSegue2"]){
        PostCollectionViewCell* cell = (PostCollectionViewCell*) sender;
        DetailedPostViewController* detailedPostViewController = [segue destinationViewController];
        detailedPostViewController.post = cell.post;
        NSLog(@"detailed post segue");
    }
}


@end
    