//
//  MRActivityIndicator.m
//  My Moncalm
//
//  Created by Mayank Rikh on 10/02/17.
//  Copyright © 2017 Mayank Rikh. All rights reserved.
//

#import "MRActivityIndicator.h"

@interface MRActivityIndicator(){
    
    UIActivityIndicatorView *activityIndicator;
}
@end


@implementation MRActivityIndicator

-(instancetype)initOnView:(UIView *)view withText:(NSString *)text{
    
    self = [super init];
    
    if(self){
        
        [self setClipsToBounds:YES];
        
        [self.layer setCornerRadius:5.0f];
        
        [self setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.80f]];
        
        [self createOnView:view];
        
        [self createInsideViews];
        
        [self createLabelWithText:text];
        
        [self stopAnimating];
    }
    
    return self;
}

-(void)createOnView:(UIView *)view{
    
    [view addSubview:self];
    
    NSMutableArray *customConstraints = [NSMutableArray new];
    
    [customConstraints addObject:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
    
    [customConstraints addObject:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f]];
    
    NSLayoutConstraint *aspectRatio = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:1.0f constant:0.0f];
    
    [aspectRatio setPriority:749];
    
    [customConstraints addObject:aspectRatio];
    
    [view addConstraints:customConstraints];
    
    [self setTranslatesAutoresizingMaskIntoConstraints:NO];
}

-(void)createInsideViews{
    
    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    [activityIndicator setHidesWhenStopped:YES];
    
    [activityIndicator setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self addSubview:activityIndicator];
    
    NSMutableArray *customConstraints = [NSMutableArray new];
    
    [customConstraints addObject:[NSLayoutConstraint constraintWithItem:activityIndicator attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
    
    [customConstraints addObject:[NSLayoutConstraint constraintWithItem:activityIndicator attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f]];
    
    [self addConstraints:customConstraints];
}

-(void)createLabelWithText:(NSString *)text{
    
    UILabel *label = [[UILabel alloc] init];
    
    [label setText:text];
    
    [label setTextAlignment:NSTextAlignmentCenter];
    
    [label setTextColor:[UIColor whiteColor]];
    
    [self addSubview:label];
    
    NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(label, activityIndicator);
    
    NSMutableArray *customConstraints = [NSMutableArray new];
    
    [customConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(5)-[label]-(5)-|" options:0 metrics:kNilOptions views:viewsDictionary]];
    
    [customConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[activityIndicator]-(5)-[label]-(5)-|" options:0 metrics:kNilOptions views:viewsDictionary]];
    
    [label setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self addConstraints:customConstraints];
}

-(void)startAnimating{
    
    [self setHidden:NO];
    
    [activityIndicator startAnimating];
}

-(void)stopAnimating{
    
    [self setHidden:YES];
    
    [activityIndicator stopAnimating];
}

@end
