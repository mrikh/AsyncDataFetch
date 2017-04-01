//
//  MRCache.h
//  DataFetchLibrary
//
//  Created by Mayank Rikh on 01/04/17.
//  Copyright © 2017 Mayank Rikh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MRCache : NSObject

@property (assign, nonatomic) NSUInteger totalCacheCapacity;

//didnt use dictionary with key being url as we need to sort based on size of each request
@property (strong, nonatomic) NSMutableArray *cachedArray;

-(instancetype)initWithCapacity:(NSUInteger)capacity;

-(void)addIntoCache:(MRCacheModel *)objectModel;

-(MRCacheModel *)getModelForRequest:(NSString *)request;

@end
