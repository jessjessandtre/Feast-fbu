//
//  AddTagViewController.m
//  Feast-fbu
//
//  Created by Jessica Shu on 8/7/18.
//  Copyright © 2018 jessjessandtre. All rights reserved.
//

#import "AddTagViewController.h"
#import "Tag.h"
#import "Recipe.h"
#import <Toast/Toast.h>

@interface AddTagViewController ()
@property (strong, nonatomic) IBOutlet UITextField *tagTextField;

@end

@implementation AddTagViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)didTapDone:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (IBAction)didTapAddTag:(id)sender {
    NSString* tagName = [self.tagTextField.text lowercaseString];
    
    [Tag tagExists:tagName forRecipe:self.recipe withCompletion:^(Boolean exists) {
        if (exists){
            [self.view makeToast:[NSString stringWithFormat:@"#%@ has already been added to this recipe", tagName] duration:2.0 position:CSToastPositionBottom];
            self.tagTextField.text = @"";
            
        } else {
            [Tag createTag:tagName forRecipe:self.recipe withCompletion:^(Boolean succeeded) {
                if (succeeded){
                    [[NSNotificationCenter defaultCenter]
                     postNotificationName:@"NewTagNotification"
                     object:nil];
                    self.tagTextField.text = @"";
                    [[self presentingViewController].view makeToast:[NSString stringWithFormat:@"Added #%@ to %@!", tagName, self.recipe.name] duration:2.0 position:CSToastPositionBottom];
                    [self dismissViewControllerAnimated:true completion:nil];

                }
            }];
        }
        
    }];
    
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
