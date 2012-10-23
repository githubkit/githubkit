//
//  GHKUser.h
//  GitHubKit
//
//  Created by Atsushi Nagase on 4/2/12.
//  Copyright (c) 2012 LittleApps Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GHKObject.h"

/** A class describes a user */
@interface GHKUser : NSObject<GHKObject>

/** User ID */
@property (nonatomic) NSInteger userId;
/** Gravatar ID */
@property (nonatomic,strong) NSString *gravatarId;
/** Login ID */
@property (nonatomic,strong) NSString *login;
/** Company */
@property (nonatomic,strong) NSString *company;
/** Email */
@property (nonatomic,strong) NSString *email;
/** Avatar image URL */
@property (nonatomic,strong) NSURL *avatarUrl;
/** Single JSON URL that describes the user */
@property (nonatomic,strong) NSURL *url;
/** Biography */
@property (nonatomic,strong) NSString *bio;
/** Name */
@property (nonatomic,strong) NSString *name;
/** Blog URL */
@property (nonatomic,strong) NSURL *blogUrl;


@end
