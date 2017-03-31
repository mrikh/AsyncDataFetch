//
//  UIView+AutoConstraint.h
//  DataFetchLibrary
//
//  Created by Mayank Rikh on 31/03/17.
//  Copyright © 2017 Mayank Rikh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (AutoConstraint)

-(void)addFullScreenView:(UIView *)view;

-(void)addView:(UIView *)view withInsets:(UIEdgeInsets)edgeInset;

@end
