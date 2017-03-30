//
//  HomeViewController.m
//  DataFetchLibrary
//
//  Created by Mayank Rikh on 30/03/17.
//  Copyright © 2017 Mayank Rikh. All rights reserved.
//

#import "HomeViewController.h"
#import "UIColor+HexString.h"
#import "UIAlertView+Api.h"
#import "HTTPHandler.h"

@interface HomeViewController ()<UIAlertViewDelegate, UITableViewDelegate, UITableViewDataSource>{
    
    __weak IBOutlet UITableView *mainTableView;
    
    NSArray *_dataArray;
    
    UIRefreshControl *_refreshControl;
}

@end

@implementation HomeViewController



- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    _refreshControl = [[UIRefreshControl alloc] init];
    
    [_refreshControl addTarget:self action:@selector(fetchRequest) forControlEvents:UIControlEventValueChanged];
    
    [mainTableView insertSubview:_refreshControl atIndex:0];
    
    //as initially we need to show without user pulling the screen
    mainTableView.contentOffset = CGPointMake(0, -_refreshControl.bounds.size.height);
    
    [self fetchRequest];
}


- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view

#pragma mark Data Source

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"homeTableViewCell"];
    
    NSDictionary *response = _dataArray[indexPath.row];
    
    NSString *hexColor = response[@"color"];
    
    cell.backgroundColor = [UIColor colorWithHexString:hexColor];
    
    return cell;
}


#pragma mark - API Calls

-(void)fetchRequest{
    
    [_refreshControl beginRefreshing];
    
    NSString *urlStringToSearch = @"http://pastebin.com/raw/wgkJgazE";
    
    [[HTTPHandler sharedInstance] getParsedDataFromUrlString:urlStringToSearch withCompletionHandler:^(id result , NSError *error) {
        
        if(!error){
            
            if ([result isKindOfClass:[NSArray class]]) {
                
                _dataArray = result;
                
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
