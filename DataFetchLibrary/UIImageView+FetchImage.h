//
//  UIImageView+FetchImage.h
//  DataFetchLibrary
//
//  Created by Mayank Rikh on 01/04/17.
//  Copyright © 2017 Mayank Rikh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (FetchImage)

-(void)downloadImageFromUrlString:(NSString *)urlString andOnCompletion:(void(^)(UIImage *image, NSError *error))completion;

-(void)cancelRequestForUrlString:(NSString *)urlString;

@end
