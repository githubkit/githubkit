//
//  GitHubKitTests.m
//  GitHubKitTests
//
//  Created by Atsushi Nagase on 4/11/12.
//  Copyright (c) 2012 LittleApps Inc. All rights reserved.
//

#import "GitHubKitTests.h"
#import <GitHubKit/GitHubKit.h>

@implementation GitHubKitTests

- (void)testGlobalFunctions {
  STAssertEqualObjects([NSURL URLWithString:@"https://api.github.com/gists/12345"], GHKAPIURL(GHKAPISingleGist, @"12345"), nil);
}

@end
