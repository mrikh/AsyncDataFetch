//
//  RequestImageView.m
//  DataFetchLibrary
//
//  Created by Mayank Rikh on 31/03/17.
//  Copyright © 2017 Mayank Rikh. All rights reserved.
//

#import "RequestImageView.h"
#import "HTTPHandler.h"

@implementation RequestImageView

-(void)setUrlToSearch:(NSString *)urlToSearch{
    
    _urlToSearch = urlToSearch;
    
    [[HTTPHandler sharedInstance] getParsedDataFromUrlString:urlToSearch withCompletionHandler:^(id result, NSError *error) {
        
        if(!error && [result isKindOfClass:[UIImage class]]){
            
            [self setImage:result];
        }
    }];
}

@end
