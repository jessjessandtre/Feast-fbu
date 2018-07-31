//
//  ProfileViewController.m
//  Feast-fbu
//
//  Created by Jessica Shu on 7/19/18.
//  Copyright © 2018 jessjessandtre. All rights reserved.
//

#import "AppDelegate.h"
#import "ProfileViewController.h"
#import "Post.h"
#import "LoginViewController.h"
#import "RecipeCollectionViewCell.h"
#import <SVProgressHUD.h>
#import "DetailedPostViewController.h"
#import "CreatePostViewController.h"
#import "Follow.h"

@interface ProfileViewController () <UICollectionViewDelegate, UICollectionViewDataSource,  UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *numberFollowersLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberFollowingLabel;

@property (weak, nonatomic) IBOutlet PFImageView *profileImageView;
@property (strong, nonatomic) IBOutlet UILabel *usernameLabel;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong, nonatomic) NSArray* posts;
@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    self.user = [PFUser currentUser];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveNotification:)
                                                 name:@"NewPostNotification"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveNotification:)
                                                 name:@"FollowUpdateNotification"
                                               object:nil];
    
    
    self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width / 2;
    self.profileImageView.clipsToBounds = YES;
    
    self.profileImageView.layer.borderColor = [UIColor greenColor].CGColor;
    self.profileImageView.layer.borderWidth = 1.5;
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    
    layout.minimumInteritemSpacing = 3;
    layout.minimumLineSpacing = 3;
    
    CGFloat postsPerLine = 3;
    CGFloat itemWidth = (self.collectionView.frame.size.width -  layout.minimumInteritemSpacing * (postsPerLine - 1))/ postsPerLine;
    CGFloat itemHeight = itemWidth;
    layout.itemSize = CGSizeMake(itemWidth,itemHeight);
    
    [SVProgressHUD show];
    [self refreshData];
}

- (void) receiveNotification: (NSNotification *) notification {
    if ([[notification name] isEqualToString:@"NewPostNotification"]) {
        NSLog (@"Successfully received the post notification!");
        [self fetchPosts];
    }
    else if ([[notification name] isEqualToString:@"FollowUpdateNotification"]) {
        NSLog(@"Successfully received the follow notification!");
        [self getNumberFollowing];
    }

}

- (void)fetchPosts {
    PFQuery *query = [PFQuery queryWithClassName:@"Post"];
    [query orderByDescending:@"createdAt"];
    [query includeKey:@"user"];
    [query whereKey:@"user" equalTo:[PFUser currentUser]];

    
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable parsePosts, NSError * _Nullable error) {
        [SVProgressHUD dismiss];
        if (!error){
            NSLog(@"fetched posts successfully");
            self.posts = parsePosts;
            [self.collectionView reloadData];
        }
        else {
            NSLog(@"error fetching posts: %@", error.localizedDescription);
            [self alertControlWithTitle:@"Error fetching data" andMessage:error.localizedDescription];

        }
    }];

}

- (void) refreshData {
    [self fetchPosts];
    self.usernameLabel.text = [PFUser currentUser].username;
    
    if (self.user[@"profileImage"] == [NSNull null]) {
        self.profileImageView.image = [UIImage imageNamed: @"profile-image-blank"];
    }
    else {
        self.profileImageView.file = self.user[@"profileImage"];
        [self.profileImageView loadInBackground];
    }
    
    [self getNumberFollowing];
    [self getNumberFollowers];
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    RecipeCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RecipeCollectionViewCell" forIndexPath:indexPath];
    Post* post = self.posts[indexPath.item];
    cell.post = post;
    return cell;
    
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.posts.count;
}


// In a storyboard-based application, you will often want to do a little preparation before navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"DetailedPostSegue"]){
        RecipeCollectionViewCell* cell = (RecipeCollectionViewCell*) sender;
        DetailedPostViewController* detailedPostViewController = [segue destinationViewController];
        detailedPostViewController.post = cell.post;
    }
}

- (IBAction)profileImageTapped:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Change Profile Photo"
                                                                   message:@"Select the source of your photo"
                                                            preferredStyle:(UIAlertControllerStyleAlert)];
    
    UIAlertAction *accessCamera = [UIAlertAction actionWithTitle:@"Camera"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                             UIImagePickerController *imagePickerVC = [UIImagePickerController new];
                                                             imagePickerVC.delegate = self;
                                                             imagePickerVC.allowsEditing = YES;
                                                             
                                                             if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                                                                 imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
                                                             }
                                                             else {
                                                                 NSLog(@"Camera 🚫 available so we will use photo library instead");
                                                                 imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                                                             }
                                                             
                                                             [self presentViewController:imagePickerVC animated:YES completion:nil];
                                                         }];
    
    
    UIAlertAction *accessCameraRoll = [UIAlertAction actionWithTitle:@"Camera Roll"
                                                               style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * _Nonnull action) {
                                                                 UIImagePickerController *imagePickerVC = [UIImagePickerController new];
                                                                 imagePickerVC.delegate = self;
                                                                 imagePickerVC.allowsEditing = YES;
                                                                 imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                                                                 
                                                                 [self presentViewController:imagePickerVC animated:YES completion:nil];
                                                             }];
    [alert addAction:accessCamera];
    [alert addAction:accessCameraRoll];
    
    [self presentViewController:alert animated:YES completion:^{
        //
    }];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    
    CGSize imageSize = CGSizeMake(200, 200);
    
    editedImage = [self resizeImage:editedImage withSize:imageSize];
    
    self.profileImageView = editedImage;
    
    [self setProfilePicture];
    
    [self dismissViewControllerAnimated:YES completion:nil];

}

- (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size {
    UIImageView *resizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
    resizeImageView.contentMode = UIViewContentModeScaleAspectFill;
    resizeImageView.image = image;
    
    UIGraphicsBeginImageContext(size);
    [resizeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (void) setProfilePicture {
    self.user[@"profileImage"] = [self getPFFileFromImage:self.profileImageView];
    
    [self.user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        self.profileImageView.file = self.user[@"profileImage"];
        [self.profileImageView loadInBackground];
    }];
    
}


- (IBAction)didTapLogout:(id)sender {
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"There was an error logging out.");
        } else {
            AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
            appDelegate.window.rootViewController = loginViewController;
        }
    }];
}

- (void) getNumberFollowing {
    [Follow numberOfFollowing:[PFUser currentUser] withCompletion:^(int following) {
        if (following != -1 ){
            self.numberFollowingLabel.text = [NSString stringWithFormat:@"%d", following];
        }
    }];

}

- (void) getNumberFollowers {
    [Follow numberOfFollowers:[PFUser currentUser] withCompletion:^(int followers) {
        if (followers != -1){
            self.numberFollowersLabel.text = [NSString stringWithFormat:@"%d", followers];
        }
    }];
}

- (PFFile *)getPFFileFromImage: (UIImage * _Nullable)image {
    
    // check if image is not nil
    if (!image) {
        return nil;
    }
    
    NSData *imageData = UIImagePNGRepresentation(image);
    // get image data and check if that is not nil
    if (!imageData) {
        return nil;
    }
    
    return [PFFile fileWithName:@"image.png" data:imageData];
}

-(void)alertControlWithTitle:(NSString*)title andMessage:(NSString*)message {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:title message:message  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //handle response
    }];
    
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:^{
        // code for after alert controller has finished presenting
    }];
}


@end
