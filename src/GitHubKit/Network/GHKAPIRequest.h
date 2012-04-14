//
//  GHKAPIRequest.h
//  GitHubKit
//
//  Created by Atsushi Nagase on 4/12/12.
//  Copyright (c) 2012 LittleApps Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

/** API request class */
@interface GHKAPIRequest : NSObject

/**  */
@property (nonatomic,strong) NSURL *URL;
/**  */
@property (nonatomic,strong) NSString *HTTPMethod;
/**  */
@property (nonatomic,strong) NSString *accessToken;
/**  */
@property (nonatomic,strong) id JSONObject;
/**  */
@property (nonatomic,readonly) BOOL requireAuthentication;
/**  */
@property (nonatomic,readonly) Class itemClass;

/**  */
+ (GHKAPIRequest *)requestWithURL:(NSURL *)URL;
/**  */
+ (GHKAPIRequest *)requestWithURL:(NSURL *)URL HTTPMethod:(NSString *)HTTPMethod;
/**  */
+ (GHKAPIRequest *)requestWithURL:(NSURL *)URL HTTPMethod:(NSString *)HTTPMethod JSONObject:(id)JSONObject;
/**  */
- (id)initWithURL:(NSURL *)URL HTTPMethod:(NSString *)HTTPMethod JSONObject:(id)JSONObject;
/**  */
- (NSURLRequest *)createURLRequest:(NSError **)error;
/**  */
- (BOOL)isExpectedStatusCode:(NSInteger)statusCode;

@end
