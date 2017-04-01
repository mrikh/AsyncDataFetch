//
//  Utilities.h
//  DataFetchLibrary
//
//  Created by Mayank Rikh on 02/04/17.
//  Copyright © 2017 Mayank Rikh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Utilities : NSObject

+(id)sharedInstance;

-(UIImage *)scaleDownImage:(UIImage *)image toSize:(CGSize)size;

-(UIImage *)takeSnapshot:(UIView *)targetView;

-(UIImage *)clipImage:(UIImage *)image withRect:(CGRect)rect;

-(void)createPopUpLabelOnView:(UIView *)view withText:(NSString *)text;

@end
