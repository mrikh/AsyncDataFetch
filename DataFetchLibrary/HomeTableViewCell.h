//
//  HomeTableViewCell.h
//  DataFetchLibrary
//
//  Created by Mayank Rikh on 31/03/17.
//  Copyright © 2017 Mayank Rikh. All rights reserved.
//

#import "RequestImageView.h"
#import <UIKit/UIKit.h>

@interface HomeTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet RequestImageView *mainImageView;
@property (weak, nonatomic) IBOutlet UIView *overlay;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end
