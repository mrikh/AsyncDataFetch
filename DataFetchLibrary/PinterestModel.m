//
//  PinterestModel.m
//  DataFetchLibrary
//
//  Created by Mayank Rikh on 31/03/17.
//  Copyright © 2017 Mayank Rikh. All rights reserved.
//

#import "PinterestModel.h"

@implementation PinterestModel

-(instancetype)initWithDictionary:(NSDictionary *)dict{
    
    if(self = [super init]){
        
        self.pinterest_id = dict[@"id"];
        self.created_at = dict[@"created_at"];
        self.width = dict[@"width"];
        self.height = dict[@"height"];
        self.color = dict[@"color"];
        self.likes = dict[@"likes"];
        self.liked_by_user = dict[@"liked_by_user"];
//        self.user = dict[@"created_at"];
//        self.pinterest_id = dict[@"id"];
//        self.created_at = dict[@"created_at"];
//        self.pinterest_id = dict[@"id"];
//        self.created_at = dict[@"created_at"];
        
    }
    
    return self;
}

@end
