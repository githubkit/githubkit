//
//  GHKAPIResponse.m
//  GitHubKit
//
//  Created by Atsushi Nagase on 4/12/12.
//  Copyright (c) 2012 LittleApps Inc. All rights reserved.
//

#import "GHKAPIResponse.h"
#import "GHKObject.h"
#import "TTGlobalCore.h"

@implementation GHKAPIResponse
@synthesize itemClass = _itemClass;
@synthesize success = _success;
@synthesize nextURL = _nextURL;
@synthesize prevURL = _prevURL;
@synthesize firstURL = _firstURL;
@synthesize httpResponse = _httpResponse;
@synthesize error = _error;

- (id)first {
  if([self.all count]>0) {
    id ret = [self.all objectAtIndex:0];
    return [ret isKindOfClass:[NSNull class]] ? nil : ret;
  }
  return nil;
}

- (id)next {
  if([self.all count]>_cursor) {
    id ret = [self.all objectAtIndex:_cursor++];
    return [ret isKindOfClass:[NSNull class]] ? nil : ret;
  }
  return nil;
}

- (NSArray *)all {
  return _items;
}

- (void)reset {
  _cursor = 0;
}

- (void)processResponse:(NSURLResponse *)response data:(NSData *)data error:(NSError *)error {
  _httpResponse = (NSHTTPURLResponse *)response;
  id json = nil;
  id<GHKObject> object = nil;
  _items = nil;
  if(self.itemClass) {
    if(data)
      json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    if(!json) {
      _success = NO;
      return;
    }
    _items = [NSMutableArray array];
    NSAssert([self.itemClass conformsToProtocol:@protocol(GHKObject)], @"%@ does not confirm to GHKObject protocol", NSStringFromClass(self.class));
    if([json isKindOfClass:[NSDictionary class]]) {
      object = [[self.itemClass alloc] initWithDictionary:json];
      [_items addObject:object];
    } else if([json isKindOfClass:[NSArray class]]) {
      for (NSDictionary *item in json) {
        object = [[self.itemClass alloc] initWithDictionary:item];
        [_items addObject:object];
      }
    }
  }
  NSDictionary *headers = _httpResponse.allHeaderFields;
  NSString *link = [headers valueForKey:@"Link"];
  NSDictionary *dict = [self parseLinkHeader:link];
  self.nextURL = [dict valueForKey:@"next"];
  self.prevURL = [dict valueForKey:@"prev"];
  self.firstURL = [dict valueForKey:@"first"];
  [self reset];
}

- (NSDictionary *)parseLinkHeader:(NSString *)headerField {
  if(!TTIsStringWithAnyText(headerField))
    return nil;
  NSArray *ar = [headerField componentsSeparatedByString:@", "];
  NSMutableDictionary *buf = [NSMutableDictionary dictionary];
  for (NSString *sec in ar) {
    NSArray *kv = [[sec stringByReplacingOccurrencesOfString:@"<" withString:@""] componentsSeparatedByString:@">; rel=\""];
    if([kv count]==2) {
      NSString *k = [[kv objectAtIndex:1] stringByReplacingOccurrencesOfString:@"\"" withString:@""];
      NSString *v = [kv objectAtIndex:0];
      if(TTIsStringWithAnyText(v)&&TTIsStringWithAnyText(k))
        [buf setValue:[NSURL URLWithString:v] forKey:k];
    }
  }
  return [buf copy];
}

@end
