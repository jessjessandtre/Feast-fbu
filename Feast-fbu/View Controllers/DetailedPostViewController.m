//
//  DetailedPostViewController.m
//  Feast-fbu
//
//  Created by Jessica Shu on 7/23/18.
//  Copyright © 2018 jessjessandtre. All rights reserved.
//

#import "DetailedPostViewController.h"
#import <ParseUI/ParseUI.h>
#import <DateTools.h>
#import "DetailViewController.h"
#import "CommentsViewController.h"
#import "Like.h"
#import "RecipeDetailViewController.h"
#import "ProfileViewController.h"
#import "ExternalProfileViewController.h"

@interface DetailedPostViewController ()

@property (strong, nonatomic) IBOutlet UILabel *usernameLabel;
@property (strong, nonatomic) IBOutlet UILabel *username2Label;
@property (strong, nonatomic) IBOutlet PFImageView *profileImageView;
@property (strong, nonatomic) IBOutlet UILabel *createdAtLabel;
@property (strong, nonatomic) IBOutlet PFImageView *postImageView;
@property (strong, nonatomic) IBOutlet UILabel *captionLabel;
@property (strong, nonatomic) IBOutlet UILabel *recipeNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (strong, nonatomic) IBOutlet UILabel *numLikesLabel;

@property (strong, nonatomic) Recipe* recipe;

@end

@implementation DetailedPostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = [NSString stringWithFormat:@"%@%@", self.post.user.username, @"'s post"];
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
    self.username2Label.text = self.post.user.username;
    self.captionLabel.text = self.post.caption;
    
    NSDate* date = self.post.createdAt;
    
    if ([date daysAgo] > 7){
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        // Configurs the input format to parse the date string
        formatter.dateFormat = @"E MMM d HH:mm:ss X y";
        // Convert String to Date
        //NSDate *date = [formatter dateFromString:createdAtOriginalString];
        // Convert output format
        formatter.dateStyle = NSDateFormatterShortStyle;
        formatter.timeStyle = NSDateFormatterNoStyle;
        self.createdAtLabel.text = [formatter stringFromDate:date];
    }
    else if ([date hoursAgo] > 24) {
        self.createdAtLabel.text = [NSString stringWithFormat:@"%.ldd",[date daysAgo]];
    }
    else if ([date minutesAgo] > 60 ) {
        self.createdAtLabel.text = [NSString stringWithFormat:@"%.fh",[date hoursAgo]];
    }
    else if ([date secondsAgo] > 60 ){
        self.createdAtLabel.text = [NSString stringWithFormat:@"%.fm",[date minutesAgo]];
    }
    else {
        self.createdAtLabel.text = [NSString stringWithFormat:@"%.fs",[date secondsAgo]];
    }
    
    self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width / 2;
    
    if (self.post.user[@"profileImage"] == nil) {
        self.profileImageView.image = [UIImage imageNamed: @"profile-image-blank"];
    }
    else {
        self.profileImageView.file = self.post.user[@"profileImage"];
        [self.profileImageView loadInBackground];
    }
    [self.profileImageView loadInBackground];
    
    
    self.postImageView.file = self.post.image;
    [self.postImageView loadInBackground];
    
    self.recipe = self.post.recipe;
    self.recipeNameLabel.text = self.recipe.name;
    /*
    Recipe* recipe = self.post.recipe;
    [recipe fetchInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
        if (object){
            self.recipeNameLabel.text = recipe.name;
            self.recipe = recipe;
        }
     else {
            NSLog(@"error loading recipe: %@", error.localizedDescription);
            self.recipeNameLabel.text = @"View this recipe";
            self.recipe = nil;
        }
    }]; */
    
    [Like userLikesPost:self.post withCompletion:^(Boolean liked) {
        if (liked){
            [self.likeButton setSelected:YES];
        }
        else {
            [self.likeButton setSelected:NO];
        }
    }];
    

    [Like numberOfLikesForPost:self.post withCompletion:^(int likes) {
        if (likes != -1) {
            self.numLikesLabel.text = [NSString stringWithFormat:@"%d", likes];
        }
    }];
}

- (IBAction)likeButtonTapped:(id)sender {
    if ([self.likeButton isSelected]){
        [Like unlikePost:self.post withCompletion:^(Boolean succeeded) {
            if (succeeded){
                [self.likeButton setSelected:NO];
                [self updateNumLikes];
            }
        }];
    }
    else {
        [Like likePost:self.post withCompletion:^(Boolean succeeded) {
            if (succeeded){
                [self.likeButton setSelected:YES];
                [self updateNumLikes];
            }
        }];
    }
    
}

- (void)updateNumLikes {
    [Like numberOfLikesForPost:self.post withCompletion:^(int likes) {
        if (likes != -1) {
            self.numLikesLabel.text = [NSString stringWithFormat:@"%d", likes];
            [Post updateLikes:likes ForPost:self.post];
        }
    }];
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"DetailedRecipeSegue"]){
        RecipeDetailViewController* detailViewController = [segue destinationViewController];
        detailViewController.recipe = self.recipe;
        
    }
    else if ([segue.identifier isEqualToString:@"CommentsSegue"]) {
        CommentsViewController *commentsViewController = [segue destinationViewController];
        commentsViewController.post = self.post;
    } else if ([segue.identifier isEqualToString:@"ProfileSegue"]) {
        NSLog(@"tapped tapped");
        ExternalProfileViewController *profileViewController = [segue destinationViewController];
        profileViewController.user = self.post.user;
    }
    else if ([segue.identifier isEqualToString:@"ProfileSegue"]) {
//        if (self.post.user == [PFUser currentUser]) {
//            ProfileViewController *profileViewController = [segue destinationViewController];
//            profileViewController.user = [PFUser currentUser];
//        }
//        else {
            ExternalProfileViewController *externalProfileViewController = [segue destinationViewController];
            externalProfileViewController.user = self.post.user;
//        }
        
    }
}

@end
