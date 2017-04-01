//
//  NavigationControllerAnimator.m
//  Owlie
//
//  Created by Mayank Rikh on 16/05/16.
//  Copyright © 2016 Mayank Rikh. All rights reserved.
//

#import "NavigationControllerAnimator.h"
#import "DetailViewController.h"
#import "HomeViewController.h"
#import "SplitViewAnimation.h"

@implementation NavigationControllerAnimator

+(id)sharedInstance{
    
    static dispatch_once_t onceQueue;
    static NavigationControllerAnimator *sharedInstance = nil;
    
    dispatch_once(&onceQueue, ^{
        
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
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

@end
