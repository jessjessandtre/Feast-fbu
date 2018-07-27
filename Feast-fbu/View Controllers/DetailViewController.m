//
//  DetailViewController.m
//  Feast-fbu
//
//  Created by Jessica Au on 7/19/18.
//  Copyright © 2018 jessjessandtre. All rights reserved.
//

#import "DetailViewController.h"
#import "UIImageView+AFNetworking.h"
#import "CreatePostViewController.h"
#import "Saved.h"
#import "RecipePostCollectionViewCell.h"

@interface DetailViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *postsCollectionView;
@property (strong, nonatomic) NSArray *posts;

@end

@implementation DetailViewController

- (void)viewDidLoad {
[super viewDidLoad];
[self refreshData];

self.postsCollectionView.delegate = self;
self.postsCollectionView.dataSource = self;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) refreshData {
    /*NSString *recipeImageURLString = self.recipe.image.url;
     NSURL *recipeImageURL = [NSURL URLWithString:recipeImageURLString];
     [self.recipeImageView setImageWithURL:recipeImageURL];
     */
    self.recipeImageView.file = self.recipe.image;
    [self.recipeImageView loadInBackground];
    
    self.recipeTitleLabel.text = self.recipe.name;
    
    NSString *ingredientsString = @"";
    for (int i = 0; i < self.recipe.ingredients.count; i++) {
        ingredientsString = [ingredientsString stringByAppendingString:[NSString stringWithFormat:@" - %@\n", self.recipe.ingredients[i]] ];
    }
    self.ingredientsLabel.text = ingredientsString;
    
    self.instructionsLabel.text = self.recipe.instructions;
    self.sourceUrlLabel.text = self.recipe.sourceURL;
    // self.numPostsLabel.text = [[self.recipe.numPosts stringValue] stringByAppendingString:@" posts"];
    
    [Saved savedRecipeExists:self.recipe withCompletion:^(Boolean saved) {
        if (saved){
            [self.saveButton setSelected:YES];
        } else {
            [self.saveButton setSelected:NO];
        }
    }];
    
}


- (IBAction)didTapPost:(id)sender {
    [self createImagePickerController];
}

- (IBAction)didTapSaveButton:(id)sender {
    UIButton* saveButton = (UIButton*)sender;
    Recipe* recipe = self.recipe;
    
    if ([saveButton isSelected]){
        [Saved deleteSavedRecipe:recipe withCompletion:^(Boolean succeeded) {
            if (succeeded){
                [saveButton setSelected:NO];
            }
        }];
    }
    else {
        [Saved saveRecipe:recipe withCompletion:^(Boolean succeeded) {
            if (succeeded){
                [saveButton setSelected:YES];
            }
        }];
    }
    
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

- (void) fetchPosts {
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    [query orderByDescending:@"createdAt"];
    [query includeKey:@"recipe"];
    [query whereKey:@"recipe" equalTo:self.recipe];
    
    query.limit = 20;
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError * _Nullable error) {
        if (posts != nil) {
            self.posts = posts;
            [self.postsCollectionView reloadData];
        } else {
            NSLog(@"Error%@", error.localizedDescription);
        }
    }];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    RecipePostCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RecipePostCell" forIndexPath:indexPath];
    Post* post = self.posts[indexPath.item];
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
    }
}



@end
