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
       
    [self addObject:objectModel];
}

-(MRCacheModel *)getModelForRequest:(NSString *)request{
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"request CONTAINS %@",request];
    
    NSArray *filteredArray = [self.cachedArray filteredArrayUsingPredicate:predicate];
    
     //as should always return 1 object so we get first object
    MRCacheModel *model = [filteredArray firstObject];
    
    //if model exists, increment by 1 as we will now use this object instead of api
    if(model){
        
        model.usageCounter += 1;
    
        [self sortObjectsArray];
    }
    
    return model;
}

#pragma mark - Private

//every time object is added, we sort
#pragma mark Sort array

-(void)sortObjectsArray{

    //sort in descending order
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"usageCounter" ascending:NO];
    
    [self.cachedArray sortUsingDescriptors:@[sortDescriptor]];
    
    //uncomment below section to confirm sorting
 /*
    [self.cachedArray enumerateObjectsUsingBlock:^(MRCacheModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSLog(@"%@",[NSString stringWithFormat:@"%@:%ld",obj.request,obj.usageCounter]);
        
    }];
    
    NSLog(@"**********\n");
  */
}


-(void)addObject:(MRCacheModel *)object{
 
    if([self shouldAddObject:object]){
        
        //this means object can be added
        
        currentCacheSize += object.responseSize;
        
        [self.cachedArray addObject:object];
        
    }else{
        
        //clear cache till memory available
        MRCacheModel *tempModel = [self.cachedArray lastObject];
        
        //remove from current memory
        
        currentCacheSize -= tempModel.responseSize;
        
        [self.cachedArray removeObject:tempModel];

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
