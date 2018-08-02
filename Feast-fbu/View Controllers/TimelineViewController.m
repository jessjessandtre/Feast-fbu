//
//  TimelineViewController.m
//  Feast-fbu
//
//  Created by Trevon Wiggs on 7/23/18.
//  Copyright © 2018 jessjessandtre. All rights reserved.
//

#import "DetailViewController.h"
#import "TimelineViewController.h"
#import "TimelineViewCell.h"
#import <SVProgressHUD.h>
#import "ProfileViewController.h"
#import "CreatePostViewController.h"
#import "Follow.h"

@interface TimelineViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray *timeline;
@property (weak, nonatomic) IBOutlet UITableView *timelineTableView;

@end

@implementation TimelineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.timelineTableView.delegate = self;
    self.timelineTableView.dataSource = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receivePostNotification:)
                                                 name:@"PostNotification"
                                               object:nil];
    
    [SVProgressHUD show];
    [self fetchTimeline];
}

- (void) receivePostNotification: (NSNotification *) notification {
    if ([[notification name] isEqualToString:@"PostNotification"]) {
        NSLog (@"Successfully received the post notification!");
        [self fetchTimeline];
        [self.timelineTableView reloadData];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TimelineViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TimelineViewCell"];
    
    Post *post = self.timeline[indexPath.row];
    
    cell.post = post;
    [cell setPost];
    return cell;
    
}

- (NSInteger)tableView:(nonnull UITableView *)timelineTableView numberOfRowsInSection:(NSInteger)section {
    return self.timeline.count;
}

- (void)fetchTimeline {
    PFQuery *followerQuery = [Follow query];
    [followerQuery includeKey:@"toUser"];
    [followerQuery whereKey:@"fromUser" equalTo:[PFUser currentUser]];
    
    PFQuery *postQuery = [Post query];
    [postQuery includeKey:@"user"];
    [postQuery includeKey:@"recipe"];
    [postQuery orderByDescending:@"createdAt"];
    [postQuery whereKey:@"user" matchesKey:@"toUser" inQuery:followerQuery];
    postQuery.limit = 20;
    
    [postQuery findObjectsInBackgroundWithBlock:^(NSArray<Post *> * _Nullable posts, NSError * _Nullable error) {
        [SVProgressHUD dismiss];
        if (posts) {
            self.timeline = posts;
            
            [self.timelineTableView reloadData];
            NSLog(@"%@", posts);
        }
        else {
            NSLog(@"%@", error.localizedDescription);
        }
        
        [self.timelineTableView reloadData];
    }];
}

- (void)didCreatePost {
    [self fetchTimeline];
    [self.timelineTableView reloadData];
}

- (void) didUpdateProfilePicture {
    [self.timelineTableView reloadData];
}





#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    DetailViewController* detailController = [segue destinationViewController];
    UITapGestureRecognizer* gestureRecognizer = (UITapGestureRecognizer*)sender;
    UILabel* label = (UILabel*)gestureRecognizer.view;
    TimelineViewCell* timelineCell = (TimelineViewCell*)[[label superview] superview];
    detailController.recipe = timelineCell.post.recipe;
    
}

@end
