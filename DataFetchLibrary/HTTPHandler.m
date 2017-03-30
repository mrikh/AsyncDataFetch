//
//  HTTPHandler.m
//  DoggyDating
//
//  Created by Mayank Rikh on 16/09/16.
//  Copyright © 2016 Acknown Technologies. All rights reserved.
//

#import "HTTPHandler.h"

@interface HTTPHandler(){
    
    NSMutableArray *_requestsArray;
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
        
        [NSURLCache setSharedURLCache:[[NSURLCache alloc] initWithMemoryCapacity:1024 * 1024 * 500 diskCapacity:0 diskPath:@"MayankCache"]];
        
        //to keep track of requests in form of session tasks
        _requestsArray = [NSMutableArray new];
    }
    
    return self;
}

#pragma mark - Public

-(void)getDataFromUrlString:(NSString *)urlString withCompletionHandler:(void(^)(NSData *result, NSError *error))completionHandler{
    
    [self sendRequestWithUrlString:urlString andHeaders:nil andBody:nil andRequestType:GET onSuccess:^(NSData *data, ContentType contentType) {
        
        completionHandler(data,nil);
        
    } andFailure:^(NSError *error) {
        
        completionHandler(nil,error);
    }];
}

-(void)getParsedDataFromUrlString:(NSString *)urlString withCompletionHandler:(void(^)(id result, NSError *error))completionHandler{
    
    [self sendRequestWithUrlString:urlString andHeaders:nil andBody:nil andRequestType:GET onSuccess:^(NSData *data, ContentType contentType) {
        
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

-(void)cancelRequestWithUrlString:(NSString *)urlString{
    
    [_requestsArray enumerateObjectsUsingBlock:^(NSURLSessionDataTask *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if([obj.originalRequest.URL.absoluteString isEqualToString:urlString]){
            
            [_requestsArray removeObject:obj];
            
            [obj cancel];
            
            *stop = YES;
        }
    }];
}

-(void)setCacheWithSize:(NSUInteger)size{
    
    [[NSURLCache sharedURLCache] setMemoryCapacity:size];
}

#pragma mark - Private methods

-(NSURLSessionDataTask *)sendRequestWithUrlString:(NSString *)string andHeaders:(NSDictionary *)headers andBody:(NSDictionary *)body andRequestType:(RequestType)requestType onSuccess:(void (^)(NSData *data, ContentType contentType))success andFailure:(void (^)(NSError *error))failure{
    
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
    
    return [self sendRequest:request andOnSuccess:success andFailure:failure];
}


-(NSURLSessionDataTask *)sendRequest:(NSMutableURLRequest *)request andOnSuccess:(void (^)(NSData *data, ContentType contentType))success andFailure:(void(^)(NSError *error))failure{
   
    NSURLSessionDataTask *sessionTask = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler: ^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (!error && [(NSHTTPURLResponse *)response statusCode]==200) {
               
                if (success) {
                    success(data, [self getContentTypeOfRequest:(NSHTTPURLResponse *)response]);
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
            
            //remove on completion
            [_requestsArray removeObject:sessionTask];
        });
    }];
    
    //add session task to array
    [_requestsArray addObject:sessionTask];
    
    [sessionTask resume];
    
    return sessionTask;
}

-(ContentType)getContentTypeOfRequest:(NSHTTPURLResponse *)response{
    
    ContentType contentType = DATA;
    
    NSString *tempString = [response.allHeaderFields valueForKey:@"Content-Type"];

    if([tempString containsString:@"text/plain"]){
        
        contentType = JSON;
    
    }else if([tempString containsString:@"image/"]){
        
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
