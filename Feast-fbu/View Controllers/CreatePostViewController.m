//
//  CreatePostViewController.m
//  Feast-fbu
//
//  Created by Jessica Shu on 7/19/18.
//  Copyright © 2018 jessjessandtre. All rights reserved.
//

#import "CreatePostViewController.h"
#import "SVProgressHUD.h"
#import "DetailViewController.h"
#import <Toast/Toast.h>
#import "Tag.h"

@interface CreatePostViewController () <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *postImageView;
@property (strong, nonatomic) IBOutlet UITextField *captionTextField;
@property (weak, nonatomic) IBOutlet UITextField *tagTextField;
@property (weak, nonatomic) IBOutlet PFImageView *profileImageView;

@end

@implementation CreatePostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.captionTextField.delegate = self;
    self.tagTextField.delegate = self;
    
    self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width / 2;
    self.profileImageView.clipsToBounds = YES;
    self.profileImageView.layer.borderColor = [UIColor colorWithRed:0.80 green:0.20 blue:0.13 alpha:1.0].CGColor;
    self.profileImageView.layer.borderWidth = 1.5;
    
    if ([PFUser currentUser][@"profileImage"] == nil) {
        self.profileImageView.image = [UIImage imageNamed: @"profile-image-blank"];
    }
    else {
        self.profileImageView.file = [PFUser currentUser][@"profileImage"];
        [self.profileImageView loadInBackground];
    }
    
    [self refreshData];
}

- (IBAction)didTapCancel:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (PFFile *)getPFFileFromImage: (UIImage *_Nullable)image {
    if (!image) {
        return nil;
    }
    
    NSData *imageData = UIImagePNGRepresentation(image);
    // get image data and check if that is not null
    if (!imageData) {
        return nil;
    }
    
    return [PFFile fileWithName:@"image.png" data:imageData];
}

- (IBAction)didTapPost:(id)sender {
    Post* post = [Post new];
    post.user = [PFUser currentUser];
    post.caption = self.captionTextField.text;
    post.image = [self getPFFileFromImage:self.image];
    [post setObject:self.recipe forKey:@"recipe"];
    
    [SVProgressHUD show];
    [post saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        [SVProgressHUD dismiss];
        if (succeeded){
            [self.recipe incrementKey:@"numPosts"];
            [self.recipe saveEventually];
            NSLog(@"post success");
            [self dismissViewControllerAnimated:true completion:nil];
            
            [[NSNotificationCenter defaultCenter]
             postNotificationName:@"NewPostNotification"
             object:nil];
        }
        else {
            NSLog(@"post error: %@", error.localizedDescription);
            [self alertControlWithTitle:@"Post error" andMessage:error.localizedDescription];
            
        }
    }];
}

- (IBAction)didTapAddTag:(id)sender {
    NSString* tagName = [self.tagTextField.text lowercaseString];
    
    [Tag tagExists:tagName forRecipe:self.recipe withCompletion:^(Boolean exists) {
        if (exists){
            [self.view makeToast:[NSString stringWithFormat:@"#%@ has already been added to this recipe", tagName] duration:2.0 position:CSToastPositionBottom];
            self.tagTextField.text = @"";

        } else {
            [Tag createTag:tagName forRecipe:self.recipe withCompletion:^(Boolean succeeded) {
                if (succeeded){
                    [self.view makeToast:[NSString stringWithFormat:@"Added #%@ to %@!", tagName, self.recipe.name] duration:2.0 position:CSToastPositionBottom];
                    [[NSNotificationCenter defaultCenter]
                     postNotificationName:@"NewTagNotification"
                     object:nil];
                    self.tagTextField.text = @"";

                }
            }];
        }

    }];
    
}


- (void)setImage:(UIImage *)image {
    _image = image;
    [self refreshData];
}

- (void)refreshData {
    self.postImageView.image = self.image;
}
- (IBAction)didTapScreen:(id)sender {
    [self.view endEditing:YES];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [UIView animateWithDuration:0.3 animations:^{
        self.view.frame = CGRectMake(self.view.frame.origin.x,self.view.frame.origin.y - 200, self.view.frame.size.width, self.view.frame.size.height);
    }];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [UIView animateWithDuration:0.3 animations:^{
        self.view.frame = CGRectMake(self.view.frame.origin.x,self.view.frame.origin.y + 200, self.view.frame.size.width, self.view.frame.size.height);
    }];
}

-(void)alertControlWithTitle:(NSString*)title andMessage:(NSString*)message {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:title message:message  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:true completion:nil];
    }];
    
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:^{
        // code for after alert controller has finished presenting
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
