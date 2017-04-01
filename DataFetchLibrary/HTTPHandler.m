//
//  HTTPHandler.m
//  DoggyDating
//
//  Created by Mayank Rikh on 16/09/16.
//  Copyright © 2016 Acknown Technologies. All rights reserved.
//

#import "MRCacheModel.h"
#import "HTTPHandler.h"
#import "MRCache.h"

@interface HTTPHandler(){
    
    MRCache *_mrCache;
}

@end

@implementation HTTPHandler

+(id)sharedInstance{
    
    static dispatch_once_t onceToken;
    
    static HTTPHandler *sharedInstance = nil;
    
    dispatch_once(&onceToken, ^{
        
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

-(instancetype)init{
    
    if(self = [super init]){
        
        //comment below line and uncomment nsurlcache to use default ios cachce THAT MAY NOT FOLLOW LRU
        
        //initially 500mb
        _mrCache = [[MRCache alloc] initWithCapacity:1024 * 1024 * 500];
//        [NSURLCache setSharedURLCache:[[NSURLCache alloc] initWithMemoryCapacity:1024 * 1024 * 500 diskCapacity:0 diskPath:@"MayankCache"]];
    }
    
    return self;
}

#pragma mark - Public

-(void)getDataFromUrlString:(NSString *)urlString andUniqueIdentifier:(NSString *)uniqueIdentifier withCompletionHandler:(void(^)(NSData *result, NSError *error))completionHandler{
    
    [self sendRequestWithUrlString:urlString andUniqueIdentifier:uniqueIdentifier andHeaders:nil andBody:nil andRequestType:GET onSuccess:^(NSData *data, ContentType contentType) {
        
        completionHandler(data,nil);
        
    } andFailure:^(NSError *error) {
        
        completionHandler(nil,error);
    }];
}

-(void)getParsedDataFromUrlString:(NSString *)urlString andUniqueIdentifier:(NSString *)uniqueIdentifier withCompletionHandler:(void(^)(id result, NSError *error))completionHandler{
    
    [self sendRequestWithUrlString:urlString andUniqueIdentifier:uniqueIdentifier andHeaders:nil andBody:nil andRequestType:GET onSuccess:^(NSData *data, ContentType contentType) {
        
        id result;
        
        switch (contentType) {
            case JSON:
                //as can be array or dict I have used id
                result = [self convertFromJson:data];
                break;
            case IMAGE:
                result = [UIImage imageWithData:data];
                break;
            case DATA:
                result = data;
                break;
        }
        
        completionHandler(result,nil);
        
    } andFailure:^(NSError *error) {
        
        completionHandler(nil,error);
    }];
}

-(void)cancelRequestWithUrlString:(NSString *)urlString andUniqueIdentifier:(NSString *)uniqueIdentifier{
    
    [[NSURLSession sharedSession] getAllTasksWithCompletionHandler:^(NSArray<__kindof NSURLSessionTask *> * _Nonnull tasks) {
        
        [tasks enumerateObjectsUsingBlock:^(__kindof NSURLSessionTask * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if ([obj.originalRequest.URL.absoluteString isEqualToString:urlString] && [obj.taskDescription isEqualToString:uniqueIdentifier]) {
                
                [obj cancel];
                
                *stop = YES;
            }
        }];
    }];
}

-(void)setCacheWithSize:(NSUInteger)size{
    
//    [[NSURLCache sharedURLCache] setMemoryCapacity:size];
    
    _mrCache.totalCacheCapacity = size;
}

#pragma mark - Private methods

-(NSURLSessionDataTask *)sendRequestWithUrlString:(NSString *)string andUniqueIdentifier:(NSString *)uniqueIdentifier andHeaders:(NSDictionary *)headers andBody:(NSDictionary *)body andRequestType:(RequestType)requestType onSuccess:(void (^)(NSData *data, ContentType contentType))success andFailure:(void (^)(NSError *error))failure{
    
    MRCacheModel *tempModel = [_mrCache getModelForRequest:string];
    
    //if found then it means it exists in cache
    if(tempModel){
            
        success(tempModel.responseData,[self getContentTypeOfString:tempModel.contentType]);
        
        return nil;
    }
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:string]];
    
    switch (requestType) {
        case GET:
            [request setHTTPMethod:@"GET"];
            break;
        case POST:
            [request setHTTPMethod:@"POST"];
            break;
        default:
            break;
    }
    
    if(headers){
        
        [headers enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            [request addValue:obj forHTTPHeaderField:key];
        }];
    }
 
    NSData *data;
    
    if(body){
        
        data = [NSJSONSerialization dataWithJSONObject:body options:0 error:nil];
        
        [request setHTTPBody:data];
    }
    
    return [self sendRequest:request andUniqueIdentifier:uniqueIdentifier andOnSuccess:success andFailure:failure];
}


-(NSURLSessionDataTask *)sendRequest:(NSMutableURLRequest *)request andUniqueIdentifier:(NSString *)identifier andOnSuccess:(void (^)(NSData *data, ContentType contentType))success andFailure:(void(^)(NSError *error))failure{
       
    NSURLSessionDataTask *sessionTask = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler: ^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (!error && [(NSHTTPURLResponse *)response statusCode]==200) {
               
                if (success) {
                    
                    NSString *responseType = [((NSHTTPURLResponse *)response).allHeaderFields valueForKey:@"Content-Type"];
                    
                     //as one image returns length -1, we don't cache it cause it can be of any size and server doesn't know actual size which may exceed total cache size
                    if(response.expectedContentLength > 0){
                        
                        //add object to dictionary
                        //as model hasn't been used even once from memory we set usageCounter 0 initially
                        NSTimeInterval timeInterval = [[NSDate date] timeIntervalSince1970];
                        
                        MRCacheModel *tempModel = [[MRCacheModel alloc] initWithData:data andContentSize:response.expectedContentLength andContentType:responseType andTime:timeInterval andRequest:request.URL.absoluteString];
                        
                        [_mrCache addIntoCache:tempModel];
                    }
                    
                    success(data, [self getContentTypeOfString:responseType]);
                }
            }
            else{
                if (failure) {
                    
                    if (!error) {
                        
                        failure([NSError errorWithDomain:@"" code:[(NSHTTPURLResponse *)response statusCode] userInfo:nil]);
                        
                    }else{
                        failure(error);
                    }
                    
                }
            }
        });
    }];
    
    [sessionTask setTaskDescription:identifier];
    
    [sessionTask resume];
    
    return sessionTask;
}


-(ContentType)getContentTypeOfString:(NSString *)string{
    
    ContentType contentType = DATA;

    if([string containsString:@"text/plain"]){
        
        contentType = JSON;
    
    }else if([string containsString:@"image/"]){
        
        contentType = IMAGE;
    }
    
    return contentType;
}


#pragma mark Data Conversion

-(id)convertFromJson:(NSData *)data{
    
    NSError *error;
    
    id result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    
    if (!error){
        
        return result;
    }else{

        //error ecocurred in conversion so send data back
        return data;
    }
}

@end
