//
//  LoginViewController.m
//  Feast-fbu
//
//  Created by Jessica Shu on 7/18/18.
//  Copyright © 2018 jessjessandtre. All rights reserved.
//

#import "LoginViewController.h"
#import <Parse/Parse.h>
#import "SVProgressHUD.h"

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;



@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)signUpUser {
    // initialize a user object
    PFUser *newUser = [PFUser user];
    
    // set user properties
    newUser.username = self.usernameTextField.text;
    // newUser.email = self.emailField.text;
    newUser.password = self.passwordTextField.text;
    
    [SVProgressHUD show];
    
    if ([self.usernameTextField.text isEqual:@""] || [self.passwordTextField.text isEqual:@""]){
        [SVProgressHUD dismiss];
        [self alertControlWithTitle:@"Sign up error" andMessage:@"Please enter a username and password"];
    }
    else {
        // call sign up function on the object
        [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
        [SVProgressHUD dismiss];
        if (error != nil) {
            NSLog(@"Error: %@", error.localizedDescription);
            [self alertControlWithTitle:@"Sign up error" andMessage:error.localizedDescription];
        } else {
            NSLog(@"User registered successfully");
            [self alertControlWithTitle:@"Sign up success" andMessage:@"Time to cook!"];
        }
        }];
    }
}

- (void)loginUser {
    NSString *username = self.usernameTextField.text;
    NSString *password = self.passwordTextField.text;
    [SVProgressHUD show];
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * user, NSError *  error) {
        [SVProgressHUD dismiss];
        if (error != nil) {
            NSLog(@"User log in failed: %@", error.localizedDescription);
            [self alertControlWithTitle:@"Login error" andMessage:error.localizedDescription];
        } else {
            NSLog(@"User logged in successfully");
            
            [self performSegueWithIdentifier:@"TabBarControllerSegue" sender:nil];

        }
    }];
}

- (IBAction)signUpButtonTapped:(id)sender {
    [self signUpUser];
}


- (IBAction)loginButtonTapped:(id)sender {
    [self loginUser];
}

- (IBAction)didTapScreen:(id)sender {
    [self.view endEditing:YES];
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
