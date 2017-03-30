//
//  UIAlertView+Api.h
//  AsynchronousFetch
//
//  Created by Mayank Rikh on 30/03/17.
//  Copyright © 2017 Mayank Rikh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertView (Api) <UIAlertViewDelegate>

-(instancetype)showApiRetryAlert;

@end
