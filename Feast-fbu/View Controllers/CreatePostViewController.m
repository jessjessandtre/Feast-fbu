//
//  CreatePostViewController.m
//  Feast-fbu
//
//  Created by Jessica Shu on 7/19/18.
//  Copyright © 2018 jessjessandtre. All rights reserved.
//

#import "CreatePostViewController.h"
#import "Post.h"

@interface CreatePostViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *postImageView;
@property (strong, nonatomic) IBOutlet UITextField *captionTextField;

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
    
    [post saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded){
            NSLog(@"post success");
            
            [self dismissViewControllerAnimated:true completion:nil];
        }
        else {
            NSLog(@"post error: %@", error.localizedDescription);
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
