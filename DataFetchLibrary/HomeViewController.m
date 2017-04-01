//
//  HomeViewController.m
//  DataFetchLibrary
//
//  Created by Mayank Rikh on 30/03/17.
//  Copyright © 2017 Mayank Rikh. All rights reserved.
//

#import "UIImageView+FetchImage.h"
#import "UIView+AutoConstraint.h"
#import "DetailViewController.h"
#import "HomeViewController.h"
#import "HomeTableViewCell.h"
#import "UIAlertView+Api.h"
#import "PinterestModel.h"
#import "HTTPHandler.h"

@interface HomeViewController ()<UIAlertViewDelegate, UITableViewDelegate, UITableViewDataSource>{
    
    __weak IBOutlet UITableView *mainTableView;

    NSMutableArray *_dataArray;
    
    UIRefreshControl *_refreshControl;
}

@end

#define initialGridViewWidth 30.0f

#define visiblePart 30.0f

@implementation HomeViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];

    _refreshControl = [[UIRefreshControl alloc] init];
    
    [_refreshControl setTintColor:[UIColor whiteColor]];
    
    [_refreshControl addTarget:self action:@selector(fetchRequest) forControlEvents:UIControlEventValueChanged];
    
    [mainTableView insertSubview:_refreshControl atIndex:0];
    
    //as initially we need to show without user pulling the screen
    mainTableView.contentOffset = CGPointMake(0, -_refreshControl.bounds.size.height);
    
    _dataArray = [NSMutableArray new];
    
    //4 mb size set
    [[HTTPHandler sharedInstance] setCacheWithSize:4 * 1024 * 1024];
    
    [self fetchRequest];
}


- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if([segue.identifier isEqualToString:@"showDetailViewController"]){
        
        DetailViewController *detailViewController = segue.destinationViewController;
        
        PinterestModel *model = _dataArray[[sender intValue]];
        
        detailViewController.backgroundImageString = model.urls.full;
    }
}


#pragma mark - Table view

#pragma mark Data Source

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [UIScreen mainScreen].bounds.size.height/3.0f;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"homeTableViewCell"];
    
    PinterestModel *model = _dataArray[indexPath.row];
    
    [cell.activityIndicator startAnimating];
    
    [cell.nameLabel setText:model.user.name];
 
    [cell.mainImageView downloadImageFromUrlString:model.user.profile_image.large andOnCompletion:^(UIImage *image, NSError *error) {
        
        if(!error){
            
            [cell.mainImageView setImage:image];
        }
        
        [cell.activityIndicator stopAnimating];
    }];
    
    return cell;
}

#pragma mark Delgate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self performSegueWithIdentifier:@"showDetailViewController" sender:@(indexPath.row)];
}

#pragma mark - API Calls

-(void)fetchRequest{
    
    if(_dataArray.count > 0){
        
        [_dataArray removeAllObjects];
    }
    
    [_refreshControl beginRefreshing];
    
    NSString *urlStringToSearch = @"http://pastebin.com/raw/wgkJgazE";
    
    [[HTTPHandler sharedInstance] getParsedDataFromUrlString:urlStringToSearch andUniqueIdentifier:@"1" withCompletionHandler:^(id result , NSError *error) {
        
        if(!error){
            
            if ([result isKindOfClass:[NSArray class]]) {
                
                [result enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    
                    if([obj isKindOfClass:[NSDictionary class]]){
                        
                        [_dataArray addObject:[[PinterestModel alloc] initWithDictionary:obj]];
                    }
                    
                }];
                
                [mainTableView reloadData];
                
            }else {
                
                NSLog(@"Unexpected data type as expecting an array");
            }
            
        }else{
            
            [self showApiFailAlert];
        }
        
        [_refreshControl endRefreshing];
    }];
}

#pragma mark - Delegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(buttonIndex == 1){
        
        [self fetchRequest];
    }
}

#pragma mark - Private Methods

-(void)showApiFailAlert{
    
    UIAlertView *apiAlert = [[UIAlertView alloc] showApiRetryAlert];
    
    apiAlert.delegate = self;
    
    [apiAlert show];
}

@end
