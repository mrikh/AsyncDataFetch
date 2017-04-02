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
#import "ListButton.h"
#import "Utilities.h"

@interface DetailViewController ()<ListButtonDelegate>{
    
    __weak IBOutlet UIImageView *mainImageView;
    __weak IBOutlet UIImageView *smallLeftImageView;
    __weak IBOutlet UIImageView *smallRightImageView;
    __weak IBOutlet ListButton *listButton;
    
    MRActivityIndicator *_activityIndicatorMain, *_activityIndicatorSmallLeft, *_activityIndicatorSmallRight;
}

@end

@implementation DetailViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    _activityIndicatorMain = [[MRActivityIndicator alloc] initOnView:mainImageView withText:@"Downloading..."];
    
    _activityIndicatorSmallLeft = [[MRActivityIndicator alloc] initOnView:smallLeftImageView withText:@"Downloading..."];
    
    _activityIndicatorSmallRight = [[MRActivityIndicator alloc] initOnView:smallRightImageView withText:@"Downloading..."];
    
    [self setupViews:mainImageView];
    [self setupViews:smallLeftImageView];
    [self setupViews:smallRightImageView];

    //buttons added in array have tag corresponding to position of their title
    //using fontawesome font as icons
    listButton.textArray = @[@"",@"",@""];
#warning cases such as too many buttons being added are not handled and if button is in top part of screen how buttons should appear isn't handled.
    
    listButton.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Button Action

- (void)startRequest{

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

- (IBAction)showButton:(UIButton *)sender{
    
    [sender setSelected:!sender.isSelected];
}

- (void)cancelSmallLeftAction{
    
    [smallLeftImageView cancelRequestForUrlString:self.backgroundImageString];
    
    [[Utilities sharedInstance] createPopUpLabelOnView:self.view withText:@"Image download cancelled"];
}


- (void)cancelSmallRightAction{
    
    [smallRightImageView cancelRequestForUrlString:self.backgroundImageString];
    
    [[Utilities sharedInstance] createPopUpLabelOnView:self.view withText:@"Image download cancelled"];
}

#pragma mark - Private

-(void)setupViews:(UIView *)view{
    
    [view.layer setBorderColor:[UIColor blackColor].CGColor];
    
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

#pragma mark Delegate

-(void)buttonPressed:(UIButton *)button{
    
    switch (button.tag) {
        case 0:
            [self startRequest];
            break;
        case 1:
            [self cancelSmallLeftAction];
            break;
        case 2:
            [self cancelSmallRightAction];
            break;
        default:
            break;
    }
}


@end
