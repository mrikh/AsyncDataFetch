//
//  PinterestModel.h
//  DataFetchLibrary
//
//  Created by Mayank Rikh on 31/03/17.
//  Copyright © 2017 Mayank Rikh. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CategoryLinksModel;
@class ProfileImageModel;
@class LinksModel;
@class UserModel;
@class UrlsModel;

@interface PinterestModel : NSObject

@property (strong, nonatomic) NSString *pinterest_id;

@property (strong, nonatomic) NSString *created_at;

@property (strong, nonatomic) NSNumber *width;

@property (strong, nonatomic) NSNumber *height;

@property (strong, nonatomic) NSString *color;

@property (strong, nonatomic) NSNumber *likes;

@property (assign, nonatomic) BOOL liked_by_user;

@property (strong, nonatomic) UserModel *user;

@property (strong, nonatomic) NSArray *current_user_collections;

@property (strong, nonatomic) UrlsModel *urls;

@property (strong, nonatomic) NSMutableArray *categories;

@end

#pragma mark - Sub Models

#pragma mark User Info model

@interface UserModel : NSObject

@property (strong, nonatomic) NSString *user_id;

@property (strong, nonatomic) NSString *username;

@property (strong, nonatomic) NSString *name;

@property (strong, nonatomic) ProfileImageModel *profile_image;

@property (strong, nonatomic) LinksModel *linksModel;

@end

#pragma mark Profile Image Model

@interface ProfileImageModel : NSObject

@property (strong, nonatomic) NSString *small;

@property (strong, nonatomic) NSString *medium;

@property (strong, nonatomic) NSString *large;

@end

#pragma mark Links Model

@interface LinksModel : NSObject

@property (strong, nonatomic) NSString *self_key;

@property (strong, nonatomic) NSString *html;

@property (strong, nonatomic) NSString *photos;

@property (strong, nonatomic) NSString *likes;

@end

#pragma mark Urls Model

@interface UrlsModel : NSObject
    
@property (strong, nonatomic) NSString *raw;

@property (strong, nonatomic) NSString *full;

@property (strong, nonatomic) NSString *regular;

@property (strong, nonatomic) NSString *small;

@property (strong, nonatomic) NSString *thumb;

@end

#pragma mark Categories Model

@interface CategoriesModel : NSObject

@property (strong, nonatomic) NSNumber *category_id;

@property (strong, nonatomic) NSString *title;

@property (strong, nonatomic) NSNumber *photo_count;

@property (strong, nonatomic) CategoryLinksModel *links;

@end

#pragma mark Category Links Model

@interface CategoryLinksModel : NSObject

@property (strong, nonatomic) NSString *self_link;

@property (strong, nonatomic) NSString *photos;

@end

#pragma mark Pinterest Links Model

@interface PinterestLinksModel : NSObject

@property (strong, nonatomic) NSString *self_link;

@property (strong, nonatomic) NSString *html;

@property (strong, nonatomic) NSString *download;

@end
