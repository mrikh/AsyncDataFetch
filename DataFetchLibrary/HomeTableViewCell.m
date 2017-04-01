//
//  HomeTableViewCell.m
//  DataFetchLibrary
//
//  Created by Mayank Rikh on 31/03/17.
//  Copyright © 2017 Mayank Rikh. All rights reserved.
//

#import "HomeTableViewCell.h"

@interface HomeTableViewCell(){
    
    CAGradientLayer *_gradientLayer;
}

@end


@implementation HomeTableViewCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    _gradientLayer = [CAGradientLayer layer];
    
    [_gradientLayer setColors:@[(id)[UIColor colorWithWhite:1 alpha:0].CGColor,(id)[UIColor blackColor].CGColor]];
    
    [self.overlay.layer addSublayer:_gradientLayer];
}

-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    [_gradientLayer setFrame:self.overlay.bounds];
}

-(void)prepareForReuse{
    
    [super prepareForReuse];
    
    [self.activityIndicator startAnimating];
}

@end
