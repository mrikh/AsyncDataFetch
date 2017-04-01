//
//  MRCacheModel.h
//  DataFetchLibrary
//
//  Created by Mayank Rikh on 01/04/17.
//  Copyright © 2017 Mayank Rikh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MRCacheModel : NSObject

@property (assign, nonatomic) NSString *request;

@property (assign, nonatomic) NSUInteger responseSize;

@property (assign, nonatomic) NSUInteger usageCounter;

@property (strong, nonatomic) NSData *responseData;

@property (assign, nonatomic) NSString *contentType;

-(instancetype)initWithData:(NSData *)responseData andContentSize:(NSUInteger)contentSize andContentType:(NSString *)contentType andUsageCounter:(NSUInteger)counter andRequest:(NSString *)request;

@end
