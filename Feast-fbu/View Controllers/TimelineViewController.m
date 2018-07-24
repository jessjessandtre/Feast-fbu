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

@interface TimelineViewController ()

@property (nonatomic, strong) NSArray *timeline;
@property (weak, nonatomic) IBOutlet UITableView *timelineTableView;

@end

@implementation TimelineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.timelineTableView.delegate = self;
    self.timelineTableView.dataSource = self;
    
    [SVProgressHUD show];
    [self fetchTimeline];
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
    PFQuery *postQuery = [Post query];
    [postQuery includeKey:@"user"];
    [postQuery includeKey:@"createdAt"];
    [postQuery orderByDescending:@"createdAt"];
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
