//
//  DetailViewController.m
//  DataFetchLibrary
//
//  Created by Mayank Rikh on 31/03/17.
//  Copyright © 2017 Mayank Rikh. All rights reserved.
//

#import "DetailViewController.h"
#import "MRActivityIndicator.h"
#import "HTTPHandler.h"

@interface DetailViewController (){
    
    __weak IBOutlet UIImageView *mainImageView;
    
    MRActivityIndicator *_activityIndicator;
}

@end

@implementation DetailViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    _activityIndicator = [[MRActivityIndicator alloc] initOnView:self.view withText:@"Fetching..."];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Button Action

- (IBAction)startRequest:(UIButton *)sender {

    [_activityIndicator startAnimating];
    
    [[HTTPHandler sharedInstance] getParsedDataFromUrlString:self.backgroundImageString withCompletionHandler:^(id result, NSError *error) {
        
        if(!error && [result isKindOfClass:[UIImage class]]){
            
            [mainImageView setImage:result];
        }
        
        [_activityIndicator stopAnimating];
        
    }];
}

- (IBAction)cancelRequest:(UIButton *)sender {

    [_activityIndicator stopAnimating];
    
    [[HTTPHandler sharedInstance] cancelRequestWithUrlString:self.backgroundImageString];
}

@end
