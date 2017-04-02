//
//  AnimatorNavigationController.m
//  DataFetchLibrary
//
//  Created by Mayank Rikh on 02/04/17.
//  Copyright © 2017 Mayank Rikh. All rights reserved.
//

#import "AnimatorNavigationController.h"
#import "DetailViewController.h"
#import "SplitViewAnimation.h"
#import "HomeViewController.h"

@interface AnimatorNavigationController ()<UINavigationControllerDelegate, UIGestureRecognizerDelegate>

@end

@implementation AnimatorNavigationController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.delegate = self;
    
    self.interactivePopGestureRecognizer.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC{
    
    if(operation == UINavigationControllerOperationPop){
        
        
    }else{
        
        if([toVC isKindOfClass:[DetailViewController class]]){
            
            SplitViewAnimation *split = [[SplitViewAnimation alloc] init];
            
            split.firstImage = ((HomeViewController *)fromVC).topImage;
            
            split.secondImage = ((HomeViewController *)fromVC).bottomImage;
            
            return split;
        }
    }
    
    return nil;
}

//have to implement this for interactive gestures to work
-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    
    return self.viewControllers.count > 1;
}

@end
