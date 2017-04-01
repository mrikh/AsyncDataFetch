//
//  DetailViewController.m
//  DataFetchLibrary
//
//  Created by Mayank Rikh on 31/03/17.
//  Copyright © 2017 Mayank Rikh. All rights reserved.
//

#import "UIImageView+FetchImage.h"
#import "DetailViewController.h"
#import "MRActivityIndicator.h"
#import "HTTPHandler.h"

@interface DetailViewController (){
    
    __weak IBOutlet UIImageView *mainImageView;
    __weak IBOutlet UIImageView *smallLeftImageView;
    __weak IBOutlet UIImageView *smallRightImageView;
    
    MRActivityIndicator *_activityIndicatorMain, *_activityIndicatorSmallLeft, *_activityIndicatorSmallRight;
}

@end

@implementation DetailViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    _activityIndicatorMain = [[MRActivityIndicator alloc] initOnView:mainImageView withText:@"Downloading main..."];
    
    _activityIndicatorSmallLeft = [[MRActivityIndicator alloc] initOnView:smallLeftImageView withText:@"Downloading left small..."];
    
    _activityIndicatorSmallRight = [[MRActivityIndicator alloc] initOnView:smallRightImageView withText:@"Downloading right small..."];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Button Action

- (IBAction)startRequest:(UIButton *)sender {

    [_activityIndicatorMain startAnimating];
    
    [_activityIndicatorSmallLeft startAnimating];
    
    [_activityIndicatorSmallRight startAnimating];
    
    //multiple resouces requesting same url
    [self downloadRequestForImageView:mainImageView andOnCompletion:^{
        
        [_activityIndicatorMain stopAnimating];
    }];
    
    [self downloadRequestForImageView:smallLeftImageView andOnCompletion:^{
        
        [_activityIndicatorSmallLeft stopAnimating];
    }];
    
    [self downloadRequestForImageView:smallRightImageView andOnCompletion:^{
        
        [_activityIndicatorSmallRight stopAnimating];
    }];
}


- (IBAction)cancelSmallLeftAction:(UIButton *)sender {
    
    [smallLeftImageView cancelRequestForUrlString:self.backgroundImageString];
}


- (IBAction)cancelSmallRightAction:(UIButton *)sender {
    
    [smallRightImageView cancelRequestForUrlString:self.backgroundImageString];
}

#pragma mark - Private

-(void)downloadRequestForImageView:(UIImageView *)imageView andOnCompletion:(void(^)(void))completion{

    [imageView downloadImageFromUrlString:self.backgroundImageString andOnCompletion:^(UIImage *image, NSError *error) {
        
        if(!error){
            
            [imageView setImage:image];
        }
        
        completion();
    }];
}

@end
