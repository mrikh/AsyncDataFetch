//
//  HomeViewController.m
//  DataFetchLibrary
//
//  Created by Mayank Rikh on 30/03/17.
//  Copyright © 2017 Mayank Rikh. All rights reserved.
//

#import "HomeCollectionViewCell.h"
#import "UIView+AutoConstraint.h"
#import "DetailViewController.h"
#import "HomeViewController.h"
#import "HomeTableViewCell.h"
#import "UIColor+HexString.h"
#import "UIAlertView+Api.h"
#import "PinterestModel.h"
#import "HTTPHandler.h"

@interface HomeViewController ()<UIAlertViewDelegate, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate>{
    
    __weak IBOutlet UICollectionView *mainCollectionView;
    __weak IBOutlet UITableView *mainTableView;
    __weak IBOutlet UIView *listContainerView;
    __weak IBOutlet UIView *gridContainerView;
    __weak IBOutlet NSLayoutConstraint *gridContainerViewWidthConstraint;
    
    NSMutableArray *_dataArray;
    
    UIRefreshControl *_refreshControl;
}

@end

#define initialGridViewWidth 30.0f

#define visiblePart 30.0f

@implementation HomeViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];

    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    
    [self.view addGestureRecognizer:panGesture];
    
    UITapGestureRecognizer *showGridGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGridSelector:)];
    
    [gridContainerView addGestureRecognizer:showGridGestureRecognizer];
    
    showGridGestureRecognizer.delegate = self;
    
    UITapGestureRecognizer *showListGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleListSelector:)];
    
    [listContainerView addGestureRecognizer:showListGestureRecognizer];
    
    showListGestureRecognizer.delegate = self;
    
    _refreshControl = [[UIRefreshControl alloc] init];
    
    [_refreshControl setTintColor:[UIColor whiteColor]];
    
    [_refreshControl addTarget:self action:@selector(fetchRequest) forControlEvents:UIControlEventValueChanged];
    
    [mainTableView insertSubview:_refreshControl atIndex:0];
    
    //as initially we need to show without user pulling the screen
    mainTableView.contentOffset = CGPointMake(0, -_refreshControl.bounds.size.height);
    
    _dataArray = [NSMutableArray new];
    
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

#pragma mark - Collection View

#pragma mark Data Source

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return _dataArray.count;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return collectionView.bounds.size;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    HomeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"homeCollectionViewCell" forIndexPath:indexPath];
    
    PinterestModel *model = _dataArray[indexPath.item];
    
    cell.mainImageView.urlToSearch = model.user.profile_image.large;
    
    return cell;
}

#pragma mark Delegate

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
     [self performSegueWithIdentifier:@"showDetailViewController" sender:@(indexPath.item)];
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
    
    [cell.nameLabel setText:model.user.name];
 
    cell.mainImageView.urlToSearch = model.user.profile_image.large;
    
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
    
    [[HTTPHandler sharedInstance] getParsedDataFromUrlString:urlStringToSearch withCompletionHandler:^(id result , NSError *error) {
        
        if(!error){
            
            if ([result isKindOfClass:[NSArray class]]) {
                
                [result enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    
                    if([obj isKindOfClass:[NSDictionary class]]){
                        
                        [_dataArray addObject:[[PinterestModel alloc] initWithDictionary:obj]];
                    }
                    
                }];
                
                [mainTableView reloadData];
                
                [mainCollectionView reloadData];
                
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


#pragma mark - Animation

-(void)handlePan:(UIPanGestureRecognizer *)recognizer{
    
    static CGPoint lastLocation;
    
    CGPoint velocity = [recognizer velocityInView:self.view];
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        
        lastLocation = [recognizer locationInView:self.view];
        
        if(velocity.x > 0 && gridContainerViewWidthConstraint.constant == initialGridViewWidth){
            
            return;
            
        }else if(velocity.x < 0 && gridContainerViewWidthConstraint.constant == [UIScreen mainScreen].bounds.size.width - visiblePart){
            
            return;
        }
        
    }else if (recognizer.state == UIGestureRecognizerStateChanged) {
        
        CGPoint currentLocation = [recognizer locationInView:self.view];
        
        float changedValue;

        if(velocity.x > 0){
            
            changedValue = currentLocation.x -  lastLocation.x;
            
            gridContainerViewWidthConstraint.constant -= changedValue;
            
        }else if(velocity.x < 0){
            
            changedValue = lastLocation.x - currentLocation.x;
            
            gridContainerViewWidthConstraint.constant += changedValue;
        }
        
        float alpha = gridContainerViewWidthConstraint.constant/([UIScreen mainScreen].bounds.size.width - visiblePart);
        
        [mainTableView setAlpha:(1.0 - alpha)];
        
        [mainCollectionView setAlpha: alpha];
        
        lastLocation = currentLocation;
        
        [mainCollectionView.collectionViewLayout invalidateLayout];
        
        [self.view layoutIfNeeded];
        
    }else if (recognizer.state == UIGestureRecognizerStateEnded || recognizer.state == UIGestureRecognizerStateCancelled) {
        
        CGFloat progress = [recognizer translationInView:self.view].x / (self.view.bounds.size.width * 1.0);
        
        if (velocity.x > 0){
            
            if (progress > 0.5){
                
                [self animateGridViewWithConstraints:initialGridViewWidth];
                
            }else{
                
                [self animateGridViewWithConstraints:[UIScreen mainScreen].bounds.size.width - visiblePart];
            }
            
        }else{
            
            if (progress < -0.5){
                
                [self animateGridViewWithConstraints:[UIScreen mainScreen].bounds.size.width - visiblePart];
                
            }else {
                
                [self animateGridViewWithConstraints:initialGridViewWidth];
            }
        }
    }
}

-(void)animateGridViewWithConstraints:(CGFloat)widthConstraint{
    
    gridContainerViewWidthConstraint.constant = widthConstraint;
    
    float alpha;
    
    if(widthConstraint == initialGridViewWidth){
        
        alpha = 1.0f;
        
    }else{
        
        alpha = 0.0f;
    }

    [mainCollectionView.collectionViewLayout invalidateLayout];
    
    [UIView animateWithDuration:0.3f animations:^{
        
        [self.view layoutIfNeeded];
        
        [mainTableView setAlpha:alpha];

        [mainCollectionView setAlpha:!alpha];
    }];
}

-(void)handleGridSelector:(UITapGestureRecognizer *)gestureRecognizer{
 
    [self animateGridViewWithConstraints:[UIScreen mainScreen].bounds.size.width - visiblePart];
}


-(void)handleListSelector:(UITapGestureRecognizer *)gestureRecognizer{
    
    [self animateGridViewWithConstraints:initialGridViewWidth];
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    if(gestureRecognizer.view ==)
}

#pragma mark - Private Methods

-(void)showApiFailAlert{
    
    UIAlertView *apiAlert = [[UIAlertView alloc] showApiRetryAlert];
    
    apiAlert.delegate = self;
    
    [apiAlert show];
}

@end
