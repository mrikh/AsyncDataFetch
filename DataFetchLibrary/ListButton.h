//
//  ListButton.h
//  DataFetchLibrary
//
//  Created by Mayank Rikh on 02/04/17.
//  Copyright © 2017 Mayank Rikh. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ListButtonDelegate <NSObject>

-(void)buttonPressed:(UIButton *)button;

@end

@interface ListButton : UIButton

@property (strong, nonatomic) NSArray *textArray;

@property (weak, nonatomic) id<ListButtonDelegate>delegate;

@end
