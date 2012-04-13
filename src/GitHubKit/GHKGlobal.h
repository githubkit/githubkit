//
//  GHKGlobal.h
//  GitHubKit
//
//  Created by Atsushi Nagase on 4/12/12.
//  Copyright (c) 2012 LittleApps Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const GHKAPIForkGist;
extern NSString *const GHKAPIGists;
extern NSString *const GHKAPIHost;
extern NSString *const GHKAPIMyGists;
extern NSString *const GHKAPIPublicGists;
extern NSString *const GHKAPISingleGist;
extern NSString *const GHKAPIStarGist;
extern NSString *const GHKAPIStarredGists;
extern NSString *const GHKAPIUser;
extern NSString *const GHKAPIUserGists;
extern NSString *const GHKAccessTokenUri;
extern NSString *const GHKErrorDomain;
extern NSString *const GHKLoginFormUriFormat;

NSURL *GHKAPIURL(NSString *api, ...);
