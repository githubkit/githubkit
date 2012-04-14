//
//  GHKUser.h
//  GitHubKit
//
//  Created by Atsushi Nagase on 4/2/12.
//  Copyright (c) 2012 LittleApps Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GitHubKit/GHKObject.h"

/** A class describes a user */
@interface GHKUser : NSObject<GHKObject>

/** User ID */
@property (nonatomic) NSInteger userId;
/** Gravatar ID */
@property (nonatomic,strong) NSString *gravatarId;
/** Login ID */
@property (nonatomic,strong) NSString *login;
/** Avatar image URL */
@property (nonatomic,strong) NSURL *avatarUrl;
/** Single JSON URL that describes the user */
@property (nonatomic,strong) NSURL *url;


@end
