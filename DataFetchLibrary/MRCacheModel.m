//
//  MRCacheModel.m
//  DataFetchLibrary
//
//  Created by Mayank Rikh on 01/04/17.
//  Copyright © 2017 Mayank Rikh. All rights reserved.
//

#import "MRCacheModel.h"

@implementation MRCacheModel

-(instancetype)initWithData:(NSData *)responseData andContentSize:(NSUInteger)contentSize andContentType:(NSString *)contentType andUsageCounter:(NSUInteger)counter andRequest:(NSString *)request{
    
    if(self = [super init]){

        self.request = request;
        
        self.responseData = responseData;
        
        self.responseSize = contentSize;
        
        self.contentType = contentType;
        
        self.usageCounter = counter;
    }
    
    return self;
}

@end
