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

@interface CreatePostViewController () 

@property (strong, nonatomic) IBOutlet UIImageView *postImageView;
@property (strong, nonatomic) IBOutlet UITextField *captionTextField;
@property (weak, nonatomic) IBOutlet UITextField *tagTextField;

@end

@implementation CreatePostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self refreshData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    PFObject *tagActivity = [PFObject objectWithClassName:@"Tag"];
    [tagActivity setObject:[self.tagTextField.text lowercaseString] forKey:@"name"];
    [tagActivity setObject:self.recipe forKey:@"recipe"];
    [tagActivity saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            NSLog(@"added tag");
        }
        else {
            NSLog(@"error adding tag %@", error.localizedDescription);
        }
    }];
    /*
    if (self.recipe[@"tags"][0] == nil) {
        self.recipe[@"tags"] = [NSMutableArray arrayWithObject:[self.tagTextField.text lowercaseString]];
        NSLog(@"Did initialize array");
    }
    else {
        [self.recipe[@"tags"] addObject:[self.tagTextField.text lowercaseString]];
        NSLog(@"Did add tag");
    }
     */
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
