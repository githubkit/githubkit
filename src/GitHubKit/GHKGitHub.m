//
//  GHKGitHub.m
//  GitHubKit
//
//  Created by Atsushi Nagase on 4/12/12.
//  Copyright (c) 2012 LittleApps Inc. All rights reserved.
//

#import "GHKAPIRequest.h"
#import "GHKAPIResponse.h"
#import "GHKGitHub.h"
#import "GHKGlobal.h"
#import "GHKUser.h"
#import "NSStringAdditions.h"
#import "TTGlobalCore.h"

#if __IPHONE_OS_VERSION_MIN_REQUIRED
#import "TTGlobalNetwork.h"
#endif

@implementation GHKGitHub

@synthesize accessToken = _accessToken;
@synthesize clientId = _clientId;
@synthesize callbackUrl = _callbackUrl;
@synthesize secret = _secret;

- (id)initWithClientId:(NSString *)clientId
                secret:(NSString *)secret
           callbackUrl:(NSString *)callbackUrl {
  if(self=[self init]) {
    self.clientId = clientId;
    self.secret = secret;
    self.callbackUrl = callbackUrl;
  }
  return self;
}

- (BOOL)isLoginFormURL:(NSURL *)URL {
  NSString *host = URL.host;
  NSString *path = URL.path;
  return
  ([host hasSuffix:@"github.com"] &&
   (
    [path isEqualToString:@"/session"] ||
    [path isEqualToString:@"/login/oauth/authorize"] ||
    [path isEqualToString:@"/login"] ||
    [path hasPrefix:@"/login/remote"])
   );
}

- (NSURL *)loginURLWithScope:(NSArray *)scope {
  return [NSURL URLWithString:
          [NSString stringWithFormat:
           GHKLoginFormUriFormat, self.clientId, self.callbackUrl,
           [scope componentsJoinedByString:@","]]];
}

- (BOOL)handleOpenURL:(NSURL *)URL
    completionHandler:(void (^)(GHKAPIResponse *res))completionHandler {
  if(![URL.absoluteString hasPrefix:self.callbackUrl])
    return NO;
  GHKAPIResponse *res = [[GHKAPIResponse alloc] init];
  NSDictionary *query = [URL.query queryContentsUsingEncoding:NSUTF8StringEncoding];
  NSString *code = TTIsArrayWithItems([query valueForKey:@"code"]) ? [[query valueForKey:@"code"] objectAtIndex:0] : nil;
  if(!TTIsStringWithAnyText(code)) {
    dispatch_async(dispatch_get_current_queue(), ^{
      res.error = [NSError errorWithDomain:GHKErrorDomain code:403 userInfo:nil];
      res.success = NO;
      completionHandler(res);
    });
    return YES;
  }
  NSURL *accessTokenURL = [NSURL URLWithString:GHKAccessTokenUri];
  NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:accessTokenURL
                                                     cachePolicy:NSURLCacheStorageNotAllowed
                                                 timeoutInterval:2000];
  req.HTTPMethod = @"POST";
  [req setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
  NSString *params = [NSString stringWithFormat:@"code=%@&client_id=%@&client_secret=%@",
                      code, self.clientId, self.secret];
  req.HTTPBody = [NSData dataWithBytes:params.UTF8String length:params.length];
  [NSURLConnection
   sendAsynchronousRequest:req
   queue:[NSOperationQueue mainQueue]
   completionHandler:^(NSURLResponse *res, NSData *data, NSError *error) {
     NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
     NSDictionary *obj = [str queryContentsUsingEncoding:NSUTF8StringEncoding];
     NSString *accessToken = [[obj valueForKey:@"access_token"] objectAtIndex:0];
     self.accessToken = accessToken;
     [self sendAsynchronousRequest:[GHKAPIRequest requestWithURL:GHKAPIURL(GHKAPIUser)]
                 completionHandler:^(GHKAPIResponse *res) {
                   completionHandler(res);
                 }];
   }];
  return YES;
  
}

- (void)sendAsynchronousRequest:(GHKAPIRequest *)request
              completionHandler:(void (^)(GHKAPIResponse *res))completionHandler {
  NSError *error = nil;
  request.accessToken = self.accessToken;
  NSURLRequest *req = [request createURLRequest:&error];
  GHKAPIResponse *res2 = [[GHKAPIResponse alloc] init];
  res2.itemClass = request.itemClass;
  if(error) {
    [res2 processResponse:nil data:nil error:error];
    res2.success = NO;
    completionHandler(res2);
    return;
  }
  GHKNetworkRequestStarted();
  [NSURLConnection
   sendAsynchronousRequest:req
   queue:[NSOperationQueue mainQueue]
   completionHandler:^(NSURLResponse *res, NSData *data, NSError *error) {
     [res2 processResponse:res data:data error:error];
     res2.success = [request isExpectedStatusCode:res2.httpResponse.statusCode];
     completionHandler(res2);
     GHKNetworkRequestStopped();
   }];
}

- (BOOL)isLoggedIn {
  return TTIsStringWithAnyText(self.accessToken);
}

- (void)logout {
  self.accessToken = nil;
}

@end
