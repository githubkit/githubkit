//
//  GHKGlobal.h
//  GitHubKit
//
//  Created by Atsushi Nagase on 4/12/12.
//  Copyright (c) 2012 LittleApps Inc. All rights reserved.
//

#import "GHKGlobal.h"

NSString *const GHKAPIHost = @"https://api.github.com";

NSString *const GHKAPIForkGist  = @"/gists/%@/fork";
NSString *const GHKAPIGists = @"/gists";
NSString *const GHKAPIMyGists = @"/gists";
NSString *const GHKAPIPublicGists = @"/gists/public";
NSString *const GHKAPISingleGist = @"/gists/%@";
NSString *const GHKAPIStarGist  = @"/gists/%@/star";
NSString *const GHKAPIStarredGists = @"/gists/starred";
NSString *const GHKAPIUser  = @"/user";
NSString *const GHKAPIUserGists = @"/users/%@/gists";
NSString *const GHKAPIGistComments  = @"/gists/%@/comments";
NSString *const GHKAPISingleGistComment  = @"/gists/comments/%@";

NSString *const GHKAccessTokenUri = @"https://github.com/login/oauth/access_token";
NSString *const GHKLoginFormUriFormat = @"https://github.com/login/oauth/authorize?client_id=%@&redirect_uri=%@&scope=%@";

NSString *const GHKErrorDomain = @"com.github.githubkit.error";

NSURL *GHKAPIURL(NSString *api, ...) {
  va_list ap;
  va_start(ap,api);
  NSString *str = [[NSString alloc] initWithFormat:api arguments:ap];
  va_end(ap);
  return [NSURL URLWithString:[GHKAPIHost stringByAppendingString:str]];
}


#if __IPHONE_OS_VERSION_MIN_REQUIRED

#import "TTGlobalNetwork.h"

void GHKNetworkRequestStarted() {
  dispatch_async(dispatch_get_main_queue(), ^{
    TTNetworkRequestStarted();
  });
}

void GHKNetworkRequestStopped() {
  dispatch_async(dispatch_get_main_queue(), ^{
    TTNetworkRequestStopped();
  });
}

#else

void GHKNetworkRequestStarted() {
}

void GHKNetworkRequestStopped() {
}
#endif