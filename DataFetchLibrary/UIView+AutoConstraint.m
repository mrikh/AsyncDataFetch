//
//  UIView+AutoConstraint.m
//  DataFetchLibrary
//
//  Created by Mayank Rikh on 31/03/17.
//  Copyright © 2017 Mayank Rikh. All rights reserved.
//

#import "UIView+AutoConstraint.h"

@implementation UIView (AutoConstraint)

-(void)addFullScreenView:(UIView *)view{
    
    [self addView:view withInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
}

-(void)addView:(UIView *)view withInsets:(UIEdgeInsets)edgeInset{
    
    NSMutableArray *constraintsArray = [NSMutableArray new];
    
    NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(view);
    
    [view setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self addSubview:view];
    
    [constraintsArray addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:|-(%f)-[view]-(%f)-|",edgeInset.left, edgeInset.right] options:kNilOptions metrics:nil views:viewsDictionary]];
    
    [constraintsArray addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|-(%f)-[view]-(%f)-|", edgeInset.top, edgeInset.bottom] options:kNilOptions metrics:nil views:viewsDictionary]];
    
    [self addConstraints:constraintsArray];
}

@end
