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
}


- (IBAction)didTapPost:(id)sender {
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
        //createPostViewController.delegate = self;
    }
}



@end
