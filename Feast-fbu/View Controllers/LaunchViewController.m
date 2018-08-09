//
//  LaunchViewController.m
//  Feast-fbu
//
//  Created by Jessica Shu on 8/9/18.
//  Copyright © 2018 jessjessandtre. All rights reserved.
//

#import "LaunchViewController.h"

@interface LaunchViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *iconImageView;

@end

@implementation LaunchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"first screen");

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.iconImageView.alpha = 0.0;
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [UIView animateWithDuration:2.5 animations:^{
        self.iconImageView.alpha = 1.0;
        [self.iconImageView setCenter:CGPointMake(self.iconImageView.center.x, self.iconImageView.center.y - 50)];
        
        
    } completion:^(BOOL finished) {
        [self performSegueWithIdentifier:@"AfterAnimationSegue" sender:nil];

    }];

    
    NSLog(@"perform segue");

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
