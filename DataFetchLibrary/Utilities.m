//
//  Utilities.m
//  DataFetchLibrary
//
//  Created by Mayank Rikh on 02/04/17.
//  Copyright © 2017 Mayank Rikh. All rights reserved.
//

#import "Utilities.h"

@implementation Utilities

+ (id)sharedInstance{
    
    static dispatch_once_t onceQueue;
    static Utilities *sharedInstance = nil;
    
    dispatch_once(&onceQueue, ^{
        
        sharedInstance = [[self alloc] init];
        
    });
    
    return sharedInstance;
}


-(void)createPopUpLabelOnView:(UIView *)view withText:(NSString *)text{
    
    __block UILabel *tempLabel = [[UILabel alloc] init];
    
    tempLabel.layer.borderColor = [UIColor blackColor].CGColor;
    
    [tempLabel setBackgroundColor:[UIColor whiteColor]];
    
    tempLabel.layer.borderWidth = 1.0f;
    
    [tempLabel setTextAlignment:NSTextAlignmentCenter];
    
    [tempLabel setText:text];
    
    [view addSubview:tempLabel];
    
    [tempLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    NSDictionary *viewDictionary = NSDictionaryOfVariableBindings(tempLabel);
    
    NSMutableArray *customConstraints = [NSMutableArray new];
    
    [customConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(-1)-[tempLabel]-(-1)-|" options:0 metrics:kNilOptions views:viewDictionary]];
    
    [customConstraints addObject:[NSLayoutConstraint constraintWithItem:tempLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:41.0f]];
    
    NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:tempLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeBottom multiplier:1 constant:41.0f];
    
    [view addConstraints:customConstraints];
    
    [view addConstraint:bottomConstraint];
    
    [view layoutIfNeeded];
    
    [bottomConstraint setConstant:1.0f];
    
    [UIView animateWithDuration:0.3f animations:^{
        
        [view layoutIfNeeded];
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [bottomConstraint setConstant:41.0f];
        
        [UIView animateWithDuration:0.3f animations:^{
            
            [view layoutIfNeeded];
            
        }completion:^(BOOL finished) {
            
            [tempLabel removeFromSuperview];
            
            tempLabel = nil;
        }];
    });
}


-(UIImage *)scaleDownImage:(UIImage *)image toSize:(CGSize)size{
    
    float actualHeight = image.size.height;
    float actualWidth = image.size.width;
    
    float finalHeight = size.height;
    float finalWidth = size.width;
    
    float imgRatio = actualWidth/actualHeight;
    float maxRatio = finalWidth/finalHeight;
    
    if(imgRatio < maxRatio)
    {
        imgRatio = finalHeight / actualHeight;
        actualWidth = imgRatio * actualWidth;
        actualHeight = finalHeight;
    }
    else
    {
        imgRatio = finalWidth / actualWidth;
        actualHeight = imgRatio * actualHeight;
        actualWidth = finalWidth;
    }
    
    
    CGRect rect = CGRectMake(0,0, actualWidth, actualHeight);
    UIGraphicsBeginImageContext(rect.size);
    [image drawInRect:rect];
    UIImage *finalImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return finalImage;
}

-(UIImage *)takeSnapshot:(UIView *)targetView{
    
    UIGraphicsBeginImageContextWithOptions(targetView.bounds.size, NO, 0);
    [targetView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


-(UIImage *)clipImage:(UIImage *)image withRect:(CGRect)rect{
    
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], rect);
    
    UIImage *newImage = [UIImage imageWithCGImage:imageRef];
    
    CGImageRelease(imageRef);
    
    return newImage;
}

@end
