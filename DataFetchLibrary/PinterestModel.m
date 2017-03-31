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
        self.liked_by_user = [dict[@"liked_by_user"] boolValue];
        self.user = [[UserModel alloc] initWithDictionary:dict[@"user"]];
        
        self.current_user_collections = [NSMutableArray new];
        
        [dict[@"current_user_collections"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            [self.current_user_collections addObject:obj];
            
        }];
        
        self.urls = [[UrlsModel alloc] initWithDictionary:dict[@"urls"]];
        
        self.categories = [NSMutableArray new];
        
        [dict[@"categories"] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if([obj isKindOfClass:[NSDictionary class]]){
            
                [self.categories addObject:[[CategoriesModel alloc] initWithDictionary:obj]];
            }
        }];
        
        self.links = [[PinterestLinksModel alloc] initWithDictionary:dict[@"links"]];
    }
    
    return self;
}

@end

#pragma mark - Sub Models

#pragma mark User Info model

@implementation UserModel

-(instancetype)initWithDictionary:(NSDictionary *)dict{
    
    if (self = [super init]) {
        
        self.user_id = dict[@"id"];
        self.username = dict[@"username"];
        self.name = dict[@"name"];
        self.profile_image = [[ProfileImageModel alloc] initWithDictionary:dict[@"profile_image"]];
        self.linksModel = [[LinksModel alloc] initWithDictionary:dict[@"links"]];
    }
    
    return self;
}

@end

#pragma mark Profile Image Model

@implementation ProfileImageModel

-(instancetype)initWithDictionary:(NSDictionary *)dict{
    
    if (self = [super init]) {
        
        self.small = dict[@"small"];
        self.medium = dict[@"medium"];
        self.large = dict[@"large"];
    }
    
    return self;
}

@end

#pragma mark Links Model

@implementation LinksModel

-(instancetype)initWithDictionary:(NSDictionary *)dict{
    
    if(self = [super init]){
        
        self.html = dict[@"html"];
        self.self_key = dict[@"self"];
        self.photos = dict[@"photos"];
        self.likes = dict[@"likes"];
    }
    
    return self;
}

@end

#pragma mark Links Model

@implementation UrlsModel

-(instancetype)initWithDictionary:(NSDictionary *)dict{
    
    if(self = [super init]){
        
        self.raw = dict[@"raw"];
        self.full = dict[@"full"];
        self.regular = dict[@"regular"];
        self.small = dict[@"thumbs"];
    }
    
    return self;
}

@end

#pragma mark Category Models

@implementation CategoriesModel

-(instancetype)initWithDictionary:(NSDictionary *)dict{
    
    if(self = [super init]){
        
        self.category_id = dict[@"id"];
        self.title = dict[@"title"];
        self.photo_count = dict[@"photo_count"];
        self.links = [[CategoryLinksModel alloc] initWithDictionary:dict[@"links"]];
    }
    
    return self;
}

@end

#pragma mark CategoryLinks Models

@implementation CategoryLinksModel

-(instancetype)initWithDictionary:(NSDictionary *)dict{
    
    if(self = [super init]){
        
        self.self_link = dict[@"self"];
        self.photos = dict[@"photos"];
    }
    
    return self;
}

@end

#pragma mark Pinterest Links Models

@implementation PinterestLinksModel

-(instancetype)initWithDictionary:(NSDictionary *)dict{
    
    if(self = [super init]){
        
        self.html = dict[@"html"];
        self.download = dict[@"download"];
        self.self_link = dict[@"self"];
    }
    
    return self;
}

@end

