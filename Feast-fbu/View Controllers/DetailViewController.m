//
//  DetailViewController.m
//  Feast-fbu
//
//  Created by Jessica Au on 7/19/18.
//  Copyright © 2018 jessjessandtre. All rights reserved.
//

#import "DetailViewController.h"
#import "UIImageView+AFNetworking.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *recipeImageURLString = self.recipe.image.url;
    NSURL *recipeImageURL = [NSURL URLWithString:recipeImageURLString];
    [self.recipeImageView setImageWithURL:recipeImageURL];
    
    self.recipeTitleLabel.text = self.recipe.name;
    
    NSString *ingredientsString;
    
    for (int i = 0; i < self.recipe.ingredients.count; i++) {
        ingredientsString = [NSString stringWithFormat: @"%@\n", ingredientsString];
    }
    
    self.ingredientsLabel.text = ingredientsString;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
