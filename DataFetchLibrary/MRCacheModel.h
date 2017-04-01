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

//since LRU we store time it was last used
@property (assign, nonatomic) NSUInteger timeOfUse;

@property (strong, nonatomic) NSData *responseData;

@property (strong, nonatomic) NSString *content;

-(instancetype)initWithData:(NSData *)responseData andContentSize:(NSUInteger)contentSize andContentType:(NSString *)content andTime:(NSTimeInterval)time andRequest:(NSString *)request;

@end
