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

@interface DetailViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self refreshData];

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
    self.numPostsLabel.text = [[self.recipe.numPosts stringValue] stringByAppendingString:@" posts"];
    
    PFQuery *saveQuery = [PFQuery queryWithClassName:@"Saved"];
    [saveQuery whereKey:@"user" equalTo:[PFUser currentUser]];
    [saveQuery whereKey:@"savedRecipe" equalTo:self.recipe];
    [saveQuery countObjectsInBackgroundWithBlock:^(int number, NSError * _Nullable error) {
        if (!error){
            if (number >= 1){
                [self.saveButton setSelected:YES];
            }
            else {
                [self.saveButton setSelected:NO];
            }
        }
        else {
            NSLog(@"error counting number of saved recipes: %@", error.localizedDescription);
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
        PFQuery* query = [PFQuery queryWithClassName:@"Saved"];
        [query whereKey:@"user" equalTo:[PFUser currentUser]];
        [query whereKey:@"savedRecipe" equalTo:recipe];
        
        [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
            if (!error){
                Saved* saved = (Saved*)objects[0];
                [saved deleteInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                    if (succeeded){
                        NSLog(@"deleted saved object");
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
                NSLog(@"error saving recipe: %@", error.localizedDescription);
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
