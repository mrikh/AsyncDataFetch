//
//  UIAlertView+Api.m
//  AsynchronousFetch
//
//  Created by Mayank Rikh on 30/03/17.
//  Copyright © 2017 Mayank Rikh. All rights reserved.
//

#import "UIAlertView+Api.h"

@implementation UIAlertView (Api)

-(instancetype)showApiRetryAlert{
    
    return [self initWithTitle:@"Sorry!" message:@"Something went wrong while processing your request" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles: @"Retry", nil];
}


@end
