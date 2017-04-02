//
//  SplitViewAnimation.m
//  Owlie
//
//  Created by Mayank Rikh on 06/06/16.
//  Copyright © 2016 Mayank Rikh. All rights reserved.
//

#import "SplitViewAnimation.h"

@interface SplitViewAnimation ()

@end

@implementation SplitViewAnimation

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
    return 0.6f;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController* toController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView* container = [transitionContext containerView];
    
    //set image views on container
    UIImageView *topImageView = [[UIImageView alloc] initWithImage:_firstImage];
    
    [topImageView setFrame:CGRectMake(0, 64.0f, [UIScreen mainScreen].bounds.size.width, _firstImage.size.height)];

    UIImageView *secondImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(topImageView.frame), _secondImage.size.width, _secondImage.size.height)];

    [secondImageView setImage:_secondImage];
    
    [container addSubview:toController.view];
    
    [toController.view setFrame:CGRectMake(0, 64.0f, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64.0f)];

    [container addSubview:topImageView];
    [container addSubview:secondImageView];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        [topImageView setFrame:CGRectMake(0, topImageView.frame.origin.y - topImageView.frame.size.height, topImageView.frame.size.width, topImageView.frame.size.height)];
        [secondImageView setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, secondImageView.frame.size.width, secondImageView.frame.size.height)];
    } completion:^(BOOL finished) {
        [topImageView removeFromSuperview];
        [secondImageView removeFromSuperview];
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}


@end
