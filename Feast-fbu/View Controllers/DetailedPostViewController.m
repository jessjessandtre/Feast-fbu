//
//  DetailedPostViewController.m
//  Feast-fbu
//
//  Created by Jessica Shu on 7/23/18.
//  Copyright © 2018 jessjessandtre. All rights reserved.
//

#import "DetailedPostViewController.h"
#import <ParseUI/ParseUI.h>

@interface DetailedPostViewController ()

@property (strong, nonatomic) IBOutlet UILabel *usernameLabel;
@property (strong, nonatomic) IBOutlet UILabel *createdAtLabel;
@property (strong, nonatomic) IBOutlet PFImageView *postImageView;
@property (strong, nonatomic) IBOutlet UILabel *captionLabel;



@end

@implementation DetailedPostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view. ter
    [self refreshData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)setPost:(Post *)post {
    _post = post;
    [self refreshData];
}

- (void) refreshData {
    self.usernameLabel.text = self.post.user.username;
    //self.createdAtLabel.text = self.post.createdAt;
    self.postImageView.file = self.post.image;
    [self.postImageView loadInBackground:^(UIImage * _Nullable image, NSError * _Nullable error) {
        
    }];
    self.captionLabel.text = self.post.caption;
    
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
