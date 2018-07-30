//
//  CommentsViewController.m
//  Feast-fbu
//
//  Created by Jessica Au on 7/25/18.
//  Copyright © 2018 jessjessandtre. All rights reserved.
//

#import "CommentsViewController.h"
#import <Parse/Parse.h>
#import "Comment.h"
#import "CommentCell.h"

@interface CommentsViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *commentsTableView;
@property (weak, nonatomic) IBOutlet UITextField *commentTextField;
@property (strong, nonatomic) NSArray *comments;

@end

@implementation CommentsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.commentsTableView.delegate = self;
    self.commentsTableView.dataSource = self;
    
    [self fetchComments];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) fetchComments {
    PFQuery *commentQuery = [PFQuery queryWithClassName:@"Comment"];
    [commentQuery includeKey:@"post"];
    [commentQuery whereKey:@"post" equalTo:self.post];
    [commentQuery orderByDescending:@"createdAt"];
    
    commentQuery.limit = 20;
    
    [commentQuery findObjectsInBackgroundWithBlock:^(NSArray<Post *> * _Nullable comments, NSError * _Nullable error) {
        if (comments) {
            self.comments = comments;
            
            [self.commentsTableView reloadData];
            NSLog(@"%@", comments);
        }
        else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommentCell" forIndexPath:indexPath];
    
    Comment *comment = self.comments[indexPath.row];
    
    cell.comment = comment;
    
    [cell setComment];
    
    return cell;fd
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.comments.count;
}

- (IBAction)commentButtonTapped:(id)sender {
    if (![self.commentTextField.text  isEqual: @""]) {
        PFObject *commentActivity = [PFObject objectWithClassName:@"Comment"];
        [commentActivity setObject:[PFUser currentUser] forKey:@"fromUser"];
        [commentActivity setObject:self.post.user forKey:@"toUser"];
        [commentActivity setObject:self.post forKey:@"post"];
        [commentActivity setObject:self.commentTextField.text forKey:@"text"];
        [commentActivity saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            [self updateNumberComments];
            [self fetchComments];
            self.commentTextField.text = @"";

        }];
        
    }
}

- (void)updateNumberComments {
    PFQuery *query = [PFQuery queryWithClassName:@"Comment"];
    [query whereKey:@"post" equalTo:self.post];
    [query countObjectsInBackgroundWithBlock:^(int number, NSError * _Nullable error) {
        self.post.numberComments = [NSNumber numberWithInt:number];
        NSLog(@"%@%d", @"number of comments is: ", number);
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
