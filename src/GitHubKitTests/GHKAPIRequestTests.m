//
//  GHKAPIRequestTests.m
//  GitHubKitTests
//
//  Created by Atsushi Nagase on 4/11/12.
//  Copyright (c) 2012 LittleApps Inc. All rights reserved.
//

#import "GHKAPIRequestTests.h"
#import <GitHubKit/GitHubKit.h>

@implementation GHKAPIRequestTests

- (void)testRequireAuthentications {
  STAssertFalse([GHKAPIRequest requestWithURL:GHKAPIURL(GHKAPIUserGists, @"ngs") HTTPMethod:@"GET"].requireAuthentication, @"List a user’s gists");
  STAssertTrue([GHKAPIRequest requestWithURL:GHKAPIURL(GHKAPIGists) HTTPMethod:@"GET"].requireAuthentication, @"List the authenticated user’s gists");
  STAssertFalse([GHKAPIRequest requestWithURL:GHKAPIURL(GHKAPIPublicGists) HTTPMethod:@"GET"].requireAuthentication, @"List all public gists");
  STAssertTrue([GHKAPIRequest requestWithURL:GHKAPIURL(GHKAPIStarredGists) HTTPMethod:@"GET"].requireAuthentication, @"List the authenticated user’s starred gists");
  //
  STAssertTrue([GHKAPIRequest requestWithURL:GHKAPIURL(GHKAPIUser) HTTPMethod:@"GET"].requireAuthentication, @"Get the authenticated user");
  STAssertTrue([GHKAPIRequest requestWithURL:GHKAPIURL(GHKAPIUser) HTTPMethod:@"PATCH"].requireAuthentication, @"Update the authenticated user");
  //
  STAssertFalse([GHKAPIRequest requestWithURL:GHKAPIURL(GHKAPISingleGist, @"12345") HTTPMethod:@"GET"].requireAuthentication , @"Get a single gist");
  STAssertTrue([GHKAPIRequest requestWithURL:GHKAPIURL(GHKAPIGists) HTTPMethod:@"POST"].requireAuthentication, @"Create a gist");
  STAssertTrue([GHKAPIRequest requestWithURL:GHKAPIURL(GHKAPISingleGist, @"12345") HTTPMethod:@"PATCH"].requireAuthentication, @"Edit a single gist");
  //
  STAssertTrue([GHKAPIRequest requestWithURL:GHKAPIURL(GHKAPIStarGist, @"12345") HTTPMethod:@"GET"].requireAuthentication, @"Check if a gist is starred");
  STAssertTrue([GHKAPIRequest requestWithURL:GHKAPIURL(GHKAPIStarGist, @"12345") HTTPMethod:@"PUT"].requireAuthentication, @"Star a gist");
  STAssertTrue([GHKAPIRequest requestWithURL:GHKAPIURL(GHKAPIStarGist, @"12345") HTTPMethod:@"DELETE"].requireAuthentication, @"Unstar a gist");
  STAssertTrue([GHKAPIRequest requestWithURL:GHKAPIURL(GHKAPIForkGist, @"12345") HTTPMethod:@"POST"].requireAuthentication, @"Fork a gist");
  STAssertTrue([GHKAPIRequest requestWithURL:GHKAPIURL(GHKAPISingleGist, @"12345") HTTPMethod:@"DELETE"].requireAuthentication, @"Delete a gist");
  //
}

- (void)testItemClass {
  STAssertEquals([GHKGist class], [GHKAPIRequest requestWithURL:GHKAPIURL(GHKAPIUserGists, @"ngs") HTTPMethod:@"GET"].itemClass, @"List a user’s gists");
  STAssertEquals([GHKGist class], [GHKAPIRequest requestWithURL:GHKAPIURL(GHKAPIGists) HTTPMethod:@"GET"].itemClass, @"List the authenticated user’s gists");
  STAssertEquals([GHKGist class], [GHKAPIRequest requestWithURL:GHKAPIURL(GHKAPIPublicGists) HTTPMethod:@"GET"].itemClass, @"List all public gists");
  STAssertEquals([GHKGist class], [GHKAPIRequest requestWithURL:GHKAPIURL(GHKAPIStarredGists) HTTPMethod:@"GET"].itemClass, @"List the authenticated user’s starred gists");
  //
  STAssertEquals([GHKUser class], [GHKAPIRequest requestWithURL:GHKAPIURL(GHKAPIUser) HTTPMethod:@"GET"].itemClass, @"Get the authenticated user");
  STAssertEquals([GHKUser class], [GHKAPIRequest requestWithURL:GHKAPIURL(GHKAPIUser) HTTPMethod:@"PATCH"].itemClass, @"Update the authenticated user");
  //
  STAssertEquals([GHKGist class], [GHKAPIRequest requestWithURL:GHKAPIURL(GHKAPISingleGist, @"12345") HTTPMethod:@"GET"].itemClass , @"Get a single gist");
  STAssertEquals([GHKGist class], [GHKAPIRequest requestWithURL:GHKAPIURL(GHKAPIGists) HTTPMethod:@"POST"].itemClass, @"Create a gist");
  STAssertEquals([GHKGist class], [GHKAPIRequest requestWithURL:GHKAPIURL(GHKAPISingleGist, @"12345") HTTPMethod:@"PATCH"].itemClass, @"Edit a single gist");
  //
  STAssertNil([GHKAPIRequest requestWithURL:GHKAPIURL(GHKAPIStarGist, @"12345") HTTPMethod:@"GET"].itemClass, @"Check if a gist is starred");
  STAssertNil([GHKAPIRequest requestWithURL:GHKAPIURL(GHKAPIStarGist, @"12345") HTTPMethod:@"PUT"].itemClass, @"Star a gist");
  STAssertNil([GHKAPIRequest requestWithURL:GHKAPIURL(GHKAPIStarGist, @"12345") HTTPMethod:@"DELETE"].itemClass, @"Unstar a gist");
  STAssertEquals([GHKGist class], [GHKAPIRequest requestWithURL:GHKAPIURL(GHKAPIForkGist, @"12345") HTTPMethod:@"POST"].itemClass, @"Fork a gist");
  STAssertNil([GHKAPIRequest requestWithURL:GHKAPIURL(GHKAPISingleGist, @"12345") HTTPMethod:@"DELETE"].itemClass, @"Delete a gist");
  //
}

- (void)testExpectedStatusCode {
  STAssertThrows([[GHKAPIRequest requestWithURL:GHKAPIURL(@"hogehoge") HTTPMethod:@"POST"] isExpectedStatusCode:200], @"Unknow URL exception shoud be thrown");
  //
  STAssertTrue([[GHKAPIRequest requestWithURL:GHKAPIURL(GHKAPIUserGists, @"ngs") HTTPMethod:@"GET"] isExpectedStatusCode:200], @"List a user’s gists");
  STAssertTrue([[GHKAPIRequest requestWithURL:GHKAPIURL(GHKAPIGists) HTTPMethod:@"GET"] isExpectedStatusCode:200], @"List the authenticated user’s gists");
  STAssertTrue([[GHKAPIRequest requestWithURL:GHKAPIURL(GHKAPIPublicGists) HTTPMethod:@"GET"] isExpectedStatusCode:200], @"List all public gists");
  STAssertTrue([[GHKAPIRequest requestWithURL:GHKAPIURL(GHKAPIStarredGists) HTTPMethod:@"GET"] isExpectedStatusCode:200], @"List the authenticated user’s starred gists");
  //
  STAssertTrue([[GHKAPIRequest requestWithURL:GHKAPIURL(GHKAPIUser) HTTPMethod:@"GET"] isExpectedStatusCode:200], @"Get the authenticated user");
  STAssertTrue([[GHKAPIRequest requestWithURL:GHKAPIURL(GHKAPIUser) HTTPMethod:@"PATCH"] isExpectedStatusCode:200], @"Update the authenticated user");
  //
  STAssertTrue([[GHKAPIRequest requestWithURL:GHKAPIURL(GHKAPISingleGist, @"12345") HTTPMethod:@"GET"] isExpectedStatusCode:200] , @"Get a single gist");
  STAssertTrue([[GHKAPIRequest requestWithURL:GHKAPIURL(GHKAPIGists) HTTPMethod:@"POST"] isExpectedStatusCode:201], @"Create a gist");
  STAssertTrue([[GHKAPIRequest requestWithURL:GHKAPIURL(GHKAPISingleGist, @"12345") HTTPMethod:@"PATCH"] isExpectedStatusCode:200], @"Edit a single gist");
  //
  STAssertFalse([[GHKAPIRequest requestWithURL:GHKAPIURL(GHKAPIStarGist, @"12345") HTTPMethod:@"GET"] isExpectedStatusCode:304], @"Check if a gist is starred - Unexpected");
  STAssertTrue([[GHKAPIRequest requestWithURL:GHKAPIURL(GHKAPIStarGist, @"12345") HTTPMethod:@"GET"] isExpectedStatusCode:204], @"Check if a gist is starred - YES");
  STAssertTrue([[GHKAPIRequest requestWithURL:GHKAPIURL(GHKAPIStarGist, @"12345") HTTPMethod:@"GET"] isExpectedStatusCode:404], @"Check if a gist is starred - NO");
  STAssertTrue([[GHKAPIRequest requestWithURL:GHKAPIURL(GHKAPIStarGist, @"12345") HTTPMethod:@"PUT"] isExpectedStatusCode:204], @"Star a gist");
  STAssertTrue([[GHKAPIRequest requestWithURL:GHKAPIURL(GHKAPIStarGist, @"12345") HTTPMethod:@"DELETE"] isExpectedStatusCode:204], @"Unstar a gist");
  STAssertTrue([[GHKAPIRequest requestWithURL:GHKAPIURL(GHKAPIForkGist, @"12345") HTTPMethod:@"POST"] isExpectedStatusCode:201], @"Fork a gist");
  STAssertTrue([[GHKAPIRequest requestWithURL:GHKAPIURL(GHKAPISingleGist, @"12345") HTTPMethod:@"DELETE"] isExpectedStatusCode:204], @"Delete a gist");
  //
}

@end
