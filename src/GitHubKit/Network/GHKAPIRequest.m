//
//  GHKAPIRequest.m
//  GitHubKit
//
//  Created by Atsushi Nagase on 4/12/12.
//  Copyright (c) 2012 LittleApps Inc. All rights reserved.
//

#import "GHKAPIRequest.h"
#import "TTGlobalCore.h"
#import "GHKGist.h"
#import "GHKUser.h"

@implementation GHKAPIRequest
@synthesize URL = _URL;
@synthesize HTTPMethod = _HTTPMethod;
@synthesize JSONObject = _JSONObject;
@synthesize accessToken = _accessToken;

+ (GHKAPIRequest *)requestWithURL:(NSURL *)URL {
  return [self requestWithURL:URL HTTPMethod:@"GET" JSONObject:nil];
}

+ (GHKAPIRequest *)requestWithURL:(NSURL *)URL HTTPMethod:(NSString *)HTTPMethod {
  return [self requestWithURL:URL HTTPMethod:HTTPMethod JSONObject:nil];
}

+ (GHKAPIRequest *)requestWithURL:(NSURL *)URL HTTPMethod:(NSString *)HTTPMethod JSONObject:(id)JSONObject {
  return [[self alloc] initWithURL:URL HTTPMethod:HTTPMethod JSONObject:JSONObject];
}

- (id)initWithURL:(NSURL *)URL HTTPMethod:(NSString *)HTTPMethod JSONObject:(id)JSONObject {
  if(self=[self init]) {
    self.URL = URL;
    self.HTTPMethod = HTTPMethod;
    self.JSONObject = JSONObject;
  }
  return self;
}

- (NSURLRequest *)createURLRequest:(NSError **)error {
  NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:self.URL];
  req.HTTPMethod = TTIsStringWithAnyText(self.HTTPMethod) ? self.HTTPMethod : @"GET";
  if(self.JSONObject) {
    NSData *data = [NSJSONSerialization dataWithJSONObject:self.JSONObject options:0 error:error];
    if(data) {
      req.HTTPBody = data;
      [req setValue:@"application/json" forHTTPHeaderField:@"content-type"];
    }
    req.cachePolicy = NSURLRequestReloadIgnoringCacheData;
  }
  if(TTIsStringWithAnyText(self.accessToken)&&self.requireAuthentication)
    [req setValue:[NSString stringWithFormat:@"bearer %@",self.accessToken] forHTTPHeaderField:@"Authorization"];
  return [req copy];
}

- (BOOL)requireAuthentication {
  NSArray *comps = [self.URL pathComponents];
  NSInteger len = [comps count];
  NSString *comp1 = len > 1 ? [comps objectAtIndex:1] : nil;
  NSString *comp2 = len > 2 ? [comps objectAtIndex:2] : nil;
  NSString *comp3 = len > 3 ? [comps objectAtIndex:3] : nil;
  switch (len) {
    case 4:
      return
      !([comp1 isEqualToString:@"users"] && [comp3 isEqualToString:@"gists"]);
    case 3:
      return
      ([comp1 isEqualToString:@"gists"] && [comp2 isEqualToString:@"starred"]) ||
      ![self.HTTPMethod isEqualToString:@"GET"];
    case 2:
      return
      [comp1 isEqualToString:@"user"] ||
      [comp1 isEqualToString:@"gists"];
  }
  return YES;
}

- (Class)itemClass {
  NSArray *comps = [self.URL pathComponents];
  NSInteger len = [comps count];
  NSString *comp1 = len > 1 ? [comps objectAtIndex:1] : nil;
  NSString *comp3 = len > 3 ? [comps objectAtIndex:3] : nil;
  switch (len) {
    case 4:
      if(
         ([comp1 isEqualToString:@"users"] && [comp3 isEqualToString:@"gists"]) ||
         ([comp1 isEqualToString:@"gists"] && [comp3 isEqualToString:@"fork"])
         )
        return [GHKGist class];
      break;
    case 3:
      if([comp1 isEqualToString:@"gists"]&&![self.HTTPMethod isEqualToString:@"DELETE"])
        return [GHKGist class];
      break;
    case 2:
      if([comp1 isEqualToString:@"gists"])
        return [GHKGist class];
      if([comp1 isEqualToString:@"user"])
        return [GHKUser class];
      break;
  }
  return nil;
}

- (BOOL)isExpectedStatusCode:(NSInteger)statusCode {
  NSArray *comps = [self.URL pathComponents];
  NSInteger len = [comps count];
  NSString *comp1 = len > 1 ? [comps objectAtIndex:1] : nil;
  NSString *comp3 = len > 3 ? [comps objectAtIndex:3] : nil;
  switch (len) {
    case 4:
      if([comp1 isEqualToString:@"users"] && [comp3 isEqualToString:@"gists"])
        return statusCode == 200;
      if([comp1 isEqualToString:@"gists"] && [comp3 isEqualToString:@"fork"])
        return statusCode == 201;
      if([comp1 isEqualToString:@"gists"] && [comp3 isEqualToString:@"star"]) {
        if([self.HTTPMethod isEqualToString:@"GET"])
          return statusCode == 204 || statusCode == 404;
        return statusCode == 204;
      }
      break;
    case 3:
      if([comp1 isEqualToString:@"gists"]) {
        if([self.HTTPMethod isEqualToString:@"DELETE"])
          return statusCode == 204;
        return statusCode == 200;
      }
      break;
    case 2:
      if([comp1 isEqualToString:@"gists"]) {
        if([self.HTTPMethod isEqualToString:@"POST"])
          return statusCode == 201;
        return statusCode == 200;
      }
      if([comp1 isEqualToString:@"user"])
        return statusCode == 200;
      break;
  }
  [NSException raise:NSInvalidArgumentException format:@"Unknown URL: %@ %@", self.HTTPMethod, self.URL.absoluteURL];
  return NO;
}
@end
