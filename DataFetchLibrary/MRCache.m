//
//  MRCache.m
//  DataFetchLibrary
//
//  Created by Mayank Rikh on 01/04/17.
//  Copyright © 2017 Mayank Rikh. All rights reserved.
//

#import "MRCacheModel.h"
#import "MRCache.h"

@interface MRCache(){
    
    NSUInteger currentCacheSize;
}

@end

@implementation MRCache

-(instancetype)initWithCapacity:(NSUInteger)capacity{
    
    if(self = [super init]){
    
        self.totalCacheCapacity = capacity;
        
        self.cachedArray = [NSMutableArray new];
        
        currentCacheSize = 0;
    }
    
    return self;
}

-(void)addIntoCache:(MRCacheModel *)objectModel{
    
    //check if object already exists, as if user sends multiple requests, we dont want same object filling up cache
    if([self searchForModelWithUrl:objectModel.request]){
        
        return;
    }
    
    [self addObject:objectModel];
}

-(MRCacheModel *)getModelForRequest:(NSString *)request{
    
     //as should always return 1 object so we get first object
    MRCacheModel *model = [self searchForModelWithUrl:request];
    
    if(model){
        
        NSTimeInterval interval = [[NSDate date] timeIntervalSince1970];
        
        model.timeOfUse = interval;
    
        [self.cachedArray removeObject:model];
        
        [self.cachedArray insertObject:model atIndex:0];
        
//        [self sortObjectsArray];
    }
    
    return model;
}

#pragma mark - Private

-(MRCacheModel *)searchForModelWithUrl:(NSString *)url{
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"request CONTAINS %@",url];
    
    NSArray *filteredArray = [[NSArray alloc] initWithArray:[self.cachedArray filteredArrayUsingPredicate:predicate]];
    
    return [filteredArray firstObject];
}


#pragma mark Sort array

-(void)sortObjectsArray{

    //sort in descending order
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timeOfUse" ascending:NO];
    
    [self.cachedArray sortUsingDescriptors:@[sortDescriptor]];
}


-(void)addObject:(MRCacheModel *)object{
 
    if([self shouldAddObject:object]){
        
        //this means object can be added
        currentCacheSize += object.responseSize;
        
        [self.cachedArray insertObject:object atIndex:0];
        
    }else{
        
        //as used objects keep getting moved to top, last object will be least recently used
        MRCacheModel *tempModel = [self.cachedArray lastObject];

        currentCacheSize -= tempModel.responseSize;
        
        [self.cachedArray removeObject:tempModel];

        //clear cache till memory available
        [self addObject:object];
    }
}

-(BOOL)shouldAddObject:(MRCacheModel *)object{
    
    NSUInteger tempSize = currentCacheSize + object.responseSize;
    
    if(tempSize < self.totalCacheCapacity){
        
        return YES;
    }else{
        
        return NO;
    }
}


@end
