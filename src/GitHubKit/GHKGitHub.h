//
//  GHKGitHub.h
//  GitHubKit
//
//  Created by Atsushi Nagase on 4/12/12.
//  Copyright (c) 2012 LittleApps Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GHKAPIRequest, GHKAPIResponse, GHKUser;

/** A GitHub REST API v3 Client */
@interface GHKGitHub : NSObject

/** Access Token */
@property (nonatomic,strong) NSString *accessToken;
/** Client ID */
@property (nonatomic,strong) NSString *clientId;
/** Callback URL */
@property (nonatomic,strong) NSString *callbackUrl;
/** Secret Key */
@property (nonatomic,strong) NSString *secret;

///---------------------------------------------------------------------------------------
/// @name Initialization
///---------------------------------------------------------------------------------------

/**
 
 Initialize new instance
 
 https://github.com/settings/applications
 
 @param clientId The Client ID
 @param secret The Secret Key
 @param callbackUrl The Callback URL
 
 */
- (id)initWithClientId:(NSString *)clientId
                secret:(NSString *)secret
           callbackUrl:(NSString *)callbackUrl;


///---------------------------------------------------------------------------------------
/// @name Authentication
///---------------------------------------------------------------------------------------

/** Returns is the URL a part of GitHub login form. */
- (BOOL)isLoginFormURL:(NSURL *)URL;

/**
 
 Returns YES if the URL is auth dialog callback.
 
 @params URL the URL
 @params completionHandler Callbacks when received access token
 
 */
- (BOOL)handleOpenURL:(NSURL *)URL
    completionHandler:(void (^)(GHKAPIResponse *res))completionHandler;

/**
 
 Returns auth dialog URL
 
 @param scope The scopes http://developer.github.com/v3/oauth/#scopes
 
 */
- (NSURL *)loginURLWithScope:(NSArray *)scope;

/** Revokes the access token */
- (void)logout;


///---------------------------------------------------------------------------------------
/// @name Network
///---------------------------------------------------------------------------------------

/**
 
 Performs an asynchronous request
 
 @param request The request to load
 @param completionHandler The handler block to execute
 */
- (void)sendAsynchronousRequest:(GHKAPIRequest *)request
              completionHandler:(void (^)(GHKAPIResponse *res))completionHandler;

@end
