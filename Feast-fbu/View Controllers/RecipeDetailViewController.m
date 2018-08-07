//
//  RecipeDetailViewController.m
//  Feast-fbu
//
//  Created by Jessica Au on 7/27/18.
//  Copyright © 2018 jessjessandtre. All rights reserved.
//

#import "UIImageView+AFNetworking.h"
#import "RecipeDetailViewController.h"
#import "Saved.h"
#import "Post.h"
#import "CreatePostViewController.h"
#import "PostCollectionViewCell.h"
#import "DetailedPostViewController.h"
#import "TagCollectionViewCell.h"
#import "Tag.h"

@interface RecipeDetailViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UINavigationControllerDelegate,UIImagePickerControllerDelegate>

//@property (weak, nonatomic) IBOutlet UICollectionView *postCollectionView;
@property (strong, nonatomic) NSArray *posts;
@property (strong, nonatomic) NSArray* tags;
@property (weak, nonatomic) IBOutlet PFImageView *recipeImageView;
@property (weak, nonatomic) IBOutlet UILabel *recipeTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *ingredientsLabel;
@property (weak, nonatomic) IBOutlet UILabel *instructionsLabel;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (strong, nonatomic) IBOutlet UITextView *urlTextView;
@property (strong, nonatomic) IBOutlet UICollectionView *postCollectionView;
@property (strong, nonatomic) IBOutlet UICollectionView *tagCollectionView;

@end

@implementation RecipeDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //self.recipeTableView.delegate = self;
    //self.recipeTableView.dataSource = self;
    self.postCollectionView.delegate = self;
    self.postCollectionView.dataSource = self;
    self.tagCollectionView.delegate = self;
    self.tagCollectionView.dataSource = self;
    
    self.navigationItem.title = self.recipe.name; 

    UICollectionViewFlowLayout *collectionViewLayout = (UICollectionViewFlowLayout*) self.postCollectionView.collectionViewLayout;
    
    collectionViewLayout.minimumInteritemSpacing = 0;
    collectionViewLayout.minimumLineSpacing = 2;
    collectionViewLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    UICollectionViewFlowLayout *tagCollectionViewLayout = (UICollectionViewFlowLayout*) self.tagCollectionView.collectionViewLayout;
    
    tagCollectionViewLayout.estimatedItemSize = CGSizeMake(1.f, 1.f);
    tagCollectionViewLayout.minimumInteritemSpacing = 0;
    tagCollectionViewLayout.minimumLineSpacing = 10;
    tagCollectionViewLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    self.saveButton.layer.cornerRadius = self.saveButton.frame.size.width / 2;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recieveNotification:) name:@"RecipeSaveNotification" object:nil];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recieveNotification:) name:@"NewPostNotification" object:nil];
    
//    UICollectionViewFlowLayout *collectionViewLayout = (UICollectionViewFlowLayout*) self.postCollectionView.collectionViewLayout;
//
//    collectionViewLayout.minimumInteritemSpacing = 0;
//    collectionViewLayout.minimumLineSpacing = 2;
//    collectionViewLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    [self refreshData];
}

- (void) refreshData {
    self.recipeImageView.file = self.recipe.image;
    [self.recipeImageView loadInBackground];
    NSLog(@"title %@", self.recipe.name);

    self.recipeTitleLabel.text = self.recipe.name;
    
    NSString *ingredientsString = @"";
    for (int i = 0; i < self.recipe.ingredients.count; i++) {
        ingredientsString = [ingredientsString stringByAppendingString:[NSString stringWithFormat:@" - %@\n", self.recipe.ingredients[i]] ];
    }
    self.ingredientsLabel.text = ingredientsString;
    
    self.instructionsLabel.text = self.recipe.instructions;
    
    [self updateSaveButton];
    
    NSMutableAttributedString* attrString = [[NSMutableAttributedString alloc] initWithString:@"View original recipe"];
    [attrString addAttribute:NSLinkAttributeName value:self.recipe.sourceURL range:NSMakeRange(0, attrString.length)];
    self.urlTextView.attributedText = attrString;
    
    [self fetchPosts];
    [self getTags];
    
}

- (void)updateSaveButton {
    [Saved savedRecipeExists:self.recipe withCompletion:^(Boolean saved) {
        if (saved){
            [self.saveButton setSelected:YES];
        } else {
            [self.saveButton setSelected:NO];
        }
    }];
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
            //[self.postCollectionView reloadData];
            [self.postCollectionView reloadData];
        } else {
            NSLog(@"Error%@", error.localizedDescription);
        }
    }];
}

- (void)getTags {
    PFQuery* query = [PFQuery queryWithClassName:@"Tag"];
    [query whereKey:@"recipe" equalTo:self.recipe];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (objects){
            self.tags = objects;
            [self.tagCollectionView reloadData];
        }
        else {
            NSLog(@"error fetching tags %@", error.localizedDescription);
        }
    }];
}

- (void) recieveNotification: (NSNotification *) notification {
    if ([[notification name] isEqualToString:@"RecipeSaveNotification"]) {
        NSLog (@"Successfully received the recipe save notification!");
        [self updateSaveButton];
    } else if ([[notification name] isEqualToString:@"NewPostNotification"]) {
        NSLog (@"Successfully received the new post notification!");
        [self fetchPosts];
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

- (IBAction)postTapped:(id)sender {
    NSLog(@"add post");
    [self createImagePickerController];
}
- (IBAction)addTagTapped:(id)sender {
    NSLog(@"add tag");
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

    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    
    // Do something with the images (based on your use case)
    CGSize imageSize = CGSizeMake(600, 600);
    editedImage = [self resizeImage:editedImage withSize:imageSize];
    
    // Dismess UIImagePickerController to go back to your original view controller
    [self dismissViewControllerAnimated:YES completion:^(){
        [self performSegueWithIdentifier:@"CreatePostSegue" sender:editedImage];
    }];
}

- (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size {
    UIImageView *resizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
    resizeImageView.contentMode = UIViewContentModeScaleAspectFill;
    resizeImageView.image = image;
    
    UIGraphicsBeginImageContext(size);
    [resizeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}
/*
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DetailRecipeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RecipeCell"];
    Recipe *recipe = self.recipe;
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.recipe = recipe;
    [cell setRecipe];
    cell.postCollectionView.dataSource = self;
    cell.postCollectionView.delegate = self;
    cell.tagCollectionView.dataSource = self;
    cell.tagCollectionView.delegate = self;
    [cell.postCollectionView reloadData];
    return cell;
}
    
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
*/
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == self.postCollectionView){
        PostCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PostCollectionViewCell" forIndexPath:indexPath];
        Post *post = self.posts[indexPath.item];
        cell.post = post;
        return cell;
    }
    else {
        TagCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TagCollectionViewCell" forIndexPath:indexPath];
        Tag* tag = self.tags[indexPath.item];
        cell.tagName = tag.name;
        return cell;
    }

}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (collectionView == self.postCollectionView){
        return self.posts.count;
    }
    else {
        return self.tags.count;
    }
}

-(UICollectionReusableView*)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    //if (kind == UICollectionElementKindSectionFooter) {
    if (collectionView == self.postCollectionView){
        UICollectionReusableView* header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"AddPostCollectionViewCell" forIndexPath:indexPath];
        return header;
    }
    else {
        UICollectionReusableView* header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"AddTagCollectionViewCell" forIndexPath:indexPath];
        return header;
    }

    
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
    
