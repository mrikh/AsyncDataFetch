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
#import "Utilities.h"

@interface DetailViewController (){
    
    __weak IBOutlet UIImageView *mainImageView;
    __weak IBOutlet UIImageView *smallLeftImageView;
    __weak IBOutlet UIImageView *smallRightImageView;
    __weak IBOutlet UIButton *cancelFirstButton;
    __weak IBOutlet UIButton *cancelSecondButton;
    __weak IBOutlet UIButton *startRequestButton;
    
    MRActivityIndicator *_activityIndicatorMain, *_activityIndicatorSmallLeft, *_activityIndicatorSmallRight;
}

@end

@implementation DetailViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    _activityIndicatorMain = [[MRActivityIndicator alloc] initOnView:mainImageView withText:@"Downloading main..."];
    
    _activityIndicatorSmallLeft = [[MRActivityIndicator alloc] initOnView:smallLeftImageView withText:@"Downloading left small..."];
    
    _activityIndicatorSmallRight = [[MRActivityIndicator alloc] initOnView:smallRightImageView withText:@"Downloading right small..."];
    
    [self setupViews:mainImageView];
    [self setupViews:smallLeftImageView];
    [self setupViews:smallRightImageView];
    [self setupViews:cancelFirstButton];
    [self setupViews:startRequestButton];
    [self setupViews:cancelSecondButton];
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
    
    [[Utilities sharedInstance] createPopUpLabelOnView:self.view withText:@"Image download cancelled"];
}


- (IBAction)cancelSmallRightAction:(UIButton *)sender {
    
    [smallRightImageView cancelRequestForUrlString:self.backgroundImageString];
    
    [[Utilities sharedInstance] createPopUpLabelOnView:self.view withText:@"Image download cancelled"];
}

#pragma mark - Private

-(void)setupViews:(UIView *)view{
    
    [view.layer setBorderColor:[UIColor whiteColor].CGColor];
    
    [view.layer setBorderWidth:1.0f];
}

-(void)downloadRequestForImageView:(UIImageView *)imageView andOnCompletion:(void(^)(void))completion{

    [imageView downloadImageFromUrlString:self.backgroundImageString andOnCompletion:^(UIImage *image, NSError *error) {
        
        if(!error){
            
            [imageView setImage:image];
        }
        
        completion();
    }];
}

@end
