//
//  ListButton.m
//  DataFetchLibrary
//
//  Created by Mayank Rikh on 02/04/17.
//  Copyright © 2017 Mayank Rikh. All rights reserved.
//

#import "ListButton.h"

@interface ListButton(){
    
    NSMutableArray *_buttonsArray;
}

@end

@implementation ListButton

-(void)awakeFromNib{
    
    [super awakeFromNib];
    
    [self setupButton:self];
    
    [self createPlus];
    
    [self createShadow];
    
    _buttonsArray = [NSMutableArray new];
}

-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    CAShapeLayer *layer = [self searchForLayer];
    
    if(layer){
        
        layer.path = [self calculatePath].CGPath;
    }
    
    //make into circle
    self.layer.cornerRadius = self.bounds.size.width/2.0f;
    
    [_buttonsArray enumerateObjectsUsingBlock:^(UIButton *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        obj.layer.cornerRadius = obj.bounds.size.width/2.0f;
    }];
    
    self.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:self.layer.cornerRadius].CGPath;
}

-(void)setSelected:(BOOL)selected{
    
    [super setSelected:selected];
    
    if(selected){
        
        [self showActions];
    }else{
        
        [self hideActions];
    }
}

#pragma mark - Private

-(void)setupButton:(UIButton *)button{
    
    button.backgroundColor = [UIColor whiteColor];
    
    button.layer.borderColor = [UIColor blackColor].CGColor;
    
    button.layer.borderWidth = 1.0f;
}


-(void)showActions{
    
    [UIView animateWithDuration:0.3f animations:^{
        
        CGAffineTransform transform = CGAffineTransformMakeRotation( -(M_PI + M_PI/4));
        self.transform = transform;
        
    }];
    
    [self createButtons];
}

-(void)hideActions{
    
    [UIView animateWithDuration:0.3f animations:^{
        
        CGAffineTransform transform = CGAffineTransformMakeRotation(0);
        self.transform = transform;
    }];
    
    [_buttonsArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    
        [UIView animateWithDuration:0.3f animations:^{
            
            [obj setCenter:self.center];
            
            [obj setAlpha:0.0f];
            
        }completion:^(BOOL finished) {
            
            [obj removeFromSuperview];
        }];
    }];
}

-(void)createShadow{
    
    self.layer.masksToBounds = NO;
    
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    
    self.layer.shadowOpacity = 0.5f;
    
    self.layer.shadowOffset = CGSizeMake(0.5f, 0.5f);
}

-(void)createPlus{
    
    CAShapeLayer *layer = [CAShapeLayer new];
    
    layer.backgroundColor = self.backgroundColor.CGColor;
    
    layer.path = [self calculatePath].CGPath;
    
    layer.lineWidth = 2.0f;
    
    layer.strokeColor = [UIColor blackColor].CGColor;
    
    [self.layer addSublayer:layer];
    
    //to uniquely identify layer
    [layer setValue:@501 forKey:@"key"];
}

-(CAShapeLayer *)searchForLayer{
    
    CAShapeLayer *layer;
    
    for (CAShapeLayer *tempLayer in self.layer.sublayers){
        
        NSNumber *number = [tempLayer valueForKey:@"key"];
        
        if (number && [number intValue] == 501){
            
            layer = tempLayer;
            
            break;
        }
    }
    
    return layer;
}

-(UIBezierPath *)calculatePath{
    
    UIBezierPath *path = [UIBezierPath new];
    
    CGFloat buttonWidth = self.bounds.size.width;
    
    CGFloat buttonHeight = self.bounds.size.height;
    
    //center point se we start
    CGPoint firstPoint = CGPointMake(buttonWidth/2.0f - buttonWidth/5.0f, buttonHeight/2.0f);
    
    CGPoint secondPoint = CGPointMake(firstPoint.x + 2 * buttonWidth/5.0f, firstPoint.y);
    
    CGPoint thirdPoint = CGPointMake(buttonWidth/2.0f, buttonHeight/2.0f- buttonHeight/5.0f);
    
    CGPoint fourthPoint = CGPointMake(thirdPoint.x, thirdPoint.y + 2 * buttonHeight/5.0f);
    
    [path moveToPoint:firstPoint];
    [path addLineToPoint:secondPoint];
    [path moveToPoint:thirdPoint];
    [path addLineToPoint:fourthPoint];
    
    return path;
}

-(void)createButtons{
    
    CGFloat width = self.bounds.size.width - self.bounds.size.width/5.0;
    
    CGFloat height = self.bounds.size.height - self.bounds.size.height/5.0f;
    
    [self.textArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        //as idx starts from 0
        UIButton *tempButton = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, width, height)];
        
        [tempButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        [tempButton setCenter:self.center];
        
        if([obj isKindOfClass:[NSString class]]){
            
            [tempButton setTitle:obj forState:UIControlStateNormal];
        }else{
         
            [tempButton setTitle:[NSString stringWithFormat:@"%ld",idx] forState:UIControlStateNormal];
        }
        
        [tempButton.titleLabel setFont:self.titleLabel.font];
        
        [tempButton setAlpha:0.0f];
        
        tempButton.tag = idx;
        
        [self setupButton:tempButton];
        
        [tempButton addTarget:self action:@selector(handleButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [_buttonsArray addObject:tempButton];
        
        [self.superview addSubview:tempButton];
        
        [UIView animateWithDuration:0.3f animations:^{
            
            tempButton.center = CGPointMake(self.center.x, self.center.y - ((idx + 1) * self.bounds.size.height));
            
            [tempButton setAlpha:1.0f];
        }];
    }];
}

-(void)handleButtonAction:(UIButton *)sender{
    
    if([self.delegate respondsToSelector:@selector(buttonPressed:)]){
        
        [self.delegate buttonPressed:sender];
    }
}

@end
