//
//  GHKAPIResponseTests.m
//  GitHubKitTests
//
//  Created by Atsushi Nagase on 4/11/12.
//  Copyright (c) 2012 LittleApps Inc. All rights reserved.
//

#import "GHKAPIResponseTests.h"
#import <GitHubKit/GitHubKit.h>

@implementation GHKAPIResponseTests


- (void)testParseLinkHeader {
  GHKAPIResponse *res = [[GHKAPIResponse alloc] init];
  NSDictionary *linkHeader = [res parseLinkHeader:@"<http://mydomain.tld/path/to/content1>; rel=\"first\", <http://mydomain.tld/path/to/content2>; rel=\"prev\", <http://mydomain.tld/path/to/content4>; rel=\"next\""];
  STAssertEqualObjects([NSURL URLWithString:@"http://mydomain.tld/path/to/content1"], [linkHeader valueForKey:@"first"], @"First link");
  STAssertEqualObjects([NSURL URLWithString:@"http://mydomain.tld/path/to/content2"], [linkHeader valueForKey:@"prev"], @"Prev link");
  STAssertEqualObjects([NSURL URLWithString:@"http://mydomain.tld/path/to/content4"], [linkHeader valueForKey:@"next"], @"Next link");
}

@end
