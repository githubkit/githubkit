//
//  GHKUser.h
//  GitHubKit
//
//  Created by Atsushi Nagase on 4/2/12.
//  Copyright (c) 2012 LittleApps Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GitHubKit/GHKObject.h"

@interface GHKUser : NSObject<GHKObject>

@property (nonatomic) NSInteger userId;
@property (nonatomic,strong) NSString *gravatarId;
@property (nonatomic,strong) NSString *login;
@property (nonatomic,strong) NSURL *avatarUrl;
@property (nonatomic,strong) NSURL *url;


@end
