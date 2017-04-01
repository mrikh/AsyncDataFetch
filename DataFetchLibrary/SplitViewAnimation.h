//
//  SplitViewAnimation.h
//  Owlie
//
//  Created by Mayank Rikh on 06/06/16.
//  Copyright © 2016 Mayank Rikh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SplitViewAnimation : UIViewController <UIViewControllerAnimatedTransitioning>

@property (strong, nonatomic) UIImage* firstImage;
@property (strong, nonatomic) UIImage* secondImage;
@property (assign, nonatomic) float splittingHeight;


@end
