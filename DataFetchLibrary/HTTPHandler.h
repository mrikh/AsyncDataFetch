//
//  HTTPHandler.h
//  DoggyDating
//
//  Created by Mayank Rikh on 16/09/16.
//  Copyright © 2016 Acknown Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum{
    JSON,
    IMAGE,
    DATA
}ContentType;

typedef enum{
    GET,
    POST
}RequestType;

@interface HTTPHandler : NSObject

+(id)sharedInstance;

-(void)getDataFromUrlString:(NSString *)urlString withCompletionHandler:(void(^)(NSData *result, NSError *error))completionHandler;

-(void)getParsedDataFromUrlString:(NSString *)urlString withCompletionHandler:(void(^)(id result, NSError *error))completionHandler;

-(void)setCacheWithSize:(NSUInteger)size;

-(void)cancelRequestWithUrlString:(NSString *)urlString;

@end
