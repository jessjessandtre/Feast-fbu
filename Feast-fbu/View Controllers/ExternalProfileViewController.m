//
//  ExternalProfileViewController.m
//  Feast-fbu
//
//  Created by Jessica Au on 7/23/18.
//  Copyright © 2018 jessjessandtre. All rights reserved.
//

#import "ExternalProfileViewController.h"
#import "Post.h"
#import "ExternalUserCollectionViewCell.h"

@interface ExternalProfileViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *externalPostTableView;

@property (weak, nonatomic) NSArray *posts;

@end

@implementation ExternalProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)followButtonTapped:(id)sender {
    PFObject *followActivity = [PFObject objectWithClassName:@"Follow"];
    [followActivity setObject:[PFUser currentUser] forKey:@"from_user"];
    [followActivity setObject:self.user forKey:@"to_user"];
    [followActivity saveEventually];
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    ExternalUserCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ExternalPostCell" forIndexPath:indexPath];
    Post* post = self.posts[indexPath.item];
    cell.post = post;
    return cell;
    
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.posts.count;
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
