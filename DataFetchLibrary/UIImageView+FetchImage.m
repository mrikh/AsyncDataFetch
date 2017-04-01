//
//  UIImageView+FetchImage.m
//  DataFetchLibrary
//
//  Created by Mayank Rikh on 01/04/17.
//  Copyright © 2017 Mayank Rikh. All rights reserved.
//

#import "UIImageView+FetchImage.h"
#import "HTTPHandler.h"

@implementation UIImageView (FetchImage)

-(void)downloadImageFromUrlString:(NSString *)urlString andOnCompletion:(void(^)(UIImage *image, NSError *error))completion{
    
    [[HTTPHandler sharedInstance] getParsedDataFromUrlString:urlString withCompletionHandler:^(id result, NSError *error) {
        
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
    
    [[HTTPHandler sharedInstance] cancelRequestWithUrlString:urlString];
}

@end
