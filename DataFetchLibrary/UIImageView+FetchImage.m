//
//  UIImageView+FetchImage.m
//  DataFetchLibrary
//
//  Created by Mayank Rikh on 01/04/17.
//  Copyright © 2017 Mayank Rikh. All rights reserved.
//

#import "UIImageView+FetchImage.h"
#import "HTTPHandler.h"
#import <objc/runtime.h>

@implementation UIImageView (FetchImage)

-(void)downloadImageFromUrlString:(NSString *)urlString andOnCompletion:(void(^)(UIImage *image, NSError *error))completion{
    
    //time stamp as unique string for each request
    self.uniqueIdentifier = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]];
    
    [[HTTPHandler sharedInstance] getParsedDataFromUrlString:urlString andUniqueIdentifier:self.uniqueIdentifier withCompletionHandler:^(id result, NSError *error) {
        
        if(!error){
            
            if([result isKindOfClass:[UIImage class]]){
                
                completion(result, nil);
                
            }else{
                
                completion(nil,[NSError errorWithDomain:@"Incorrect return type" code:-1 userInfo:nil]);
            }
            
        }else{
            
            completion(nil,error);
        }
        
    }];
}

-(void)cancelRequestForUrlString:(NSString *)urlString{
    
    [[HTTPHandler sharedInstance] cancelRequestWithUrlString:urlString andUniqueIdentifier:self.uniqueIdentifier];
}


//Objective - C runtime - to add value to the property
-(NSString *)uniqueIdentifier{
    
    return objc_getAssociatedObject(self, @selector(uniqueIdentifier));
}

-(void)setUniqueIdentifier:(NSString *)uniqueIdentifier{
    
    objc_setAssociatedObject(self, @selector(uniqueIdentifier),
                             uniqueIdentifier, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
