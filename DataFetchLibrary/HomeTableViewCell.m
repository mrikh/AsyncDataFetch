//
//  HomeTableViewCell.m
//  DataFetchLibrary
//
//  Created by Mayank Rikh on 31/03/17.
//  Copyright © 2017 Mayank Rikh. All rights reserved.
//

#import "HomeTableViewCell.h"

@implementation HomeTableViewCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
}


-(void)prepareForReuse{
    
    [super prepareForReuse];
    
    self.mainImageView.image = nil;
}

@end
