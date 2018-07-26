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

@interface DetailedPostViewController ()

@property (strong, nonatomic) IBOutlet UILabel *usernameLabel;
@property (strong, nonatomic) IBOutlet UILabel *username2Label;
@property (strong, nonatomic) IBOutlet PFImageView *profileImageView;
@property (strong, nonatomic) IBOutlet UILabel *createdAtLabel;
@property (strong, nonatomic) IBOutlet PFImageView *postImageView;
@property (strong, nonatomic) IBOutlet UILabel *captionLabel;
@property (strong, nonatomic) IBOutlet UILabel *recipeNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;

@property (strong, nonatomic) Recipe* recipe;

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
    
    self.postImageView.file = self.post.image;
    [self.postImageView loadInBackground];
    
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
    }];
}

- (IBAction)likeButtonTapped:(id)sender {
    PFObject *likeActivity = [PFObject objectWithClassName:@"Like"];
    [likeActivity setObject:[PFUser currentUser] forKey:@"fromUser"];
    [likeActivity setObject:self.post.user forKey:@"toUser"];
    [likeActivity setObject:self.post forKey:@"post"];
    [likeActivity saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        [self updateNumberLikes];
    }];
    
    self.likeButton.enabled = NO;
}

- (void)updateNumberLikes {
    PFQuery *query = [PFQuery queryWithClassName:@"Like"];
    [query whereKey:@"post" equalTo:self.post];
    [query countObjectsInBackgroundWithBlock:^(int number, NSError * _Nullable error) {
        self.post.numberLikes = [NSNumber numberWithInt:number];
        NSLog(@"%@%d", @"number of likes is: ", number);
    }];
}




#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"DetailedRecipeSegue"]){
        NSLog(@"segue");
        DetailViewController* detailViewController = [segue destinationViewController];
        detailViewController.recipe = self.recipe;
        
    }
    else if ([segue.identifier isEqualToString:@"CommentsSegue"]) {
        CommentsViewController *commentsViewController = [segue destinationViewController];
        commentsViewController.post = self.post;
    }
}


@end
