//
//  GHKGitHub.h
//  GitHubKit
//
//  Created by Atsushi Nagase on 4/12/12.
//  Copyright (c) 2012 LittleApps Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GHKAPIRequest;
@class GHKAPIResponse;
@class GHKUser;
@interface GHKGitHub : NSObject

/**
 * Current user if logged in
 */
@property (nonatomic,strong) GHKUser *currentUser;
@property (nonatomic,strong) NSString *accessToken;
@property (nonatomic,strong) NSString *clientId;
@property (nonatomic,strong) NSString *redirectUri;
@property (nonatomic,strong) NSString *secret;

- (id)initWithClientId:(NSString *)clientId
                secret:(NSString *)secret
           redirectUri:(NSString *)redirectUri;

- (BOOL)isLoginFormURL:(NSURL *)URL;

- (BOOL)handleOpenURL:(NSURL *)URL
    completionHandler:(void (^)(GHKAPIResponse *res))completionHandler;

- (NSURL *)loginURLWithScope:(NSArray *)scope;

- (void)sendAsynchronousRequest:(GHKAPIRequest *)request
              completionHandler:(void (^)(GHKAPIResponse *res))completionHandler;

- (void)logout;

@end
