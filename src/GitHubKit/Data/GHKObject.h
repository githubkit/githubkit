//
//  GHKObject.h
//  GitHubKit
//
//  Created by Atsushi Nagase on 4/11/12.
//  Copyright (c) 2012 LittleApps Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

/** GHKObject protocol is a base protocol of all object types */
@protocol GHKObject <NSObject,NSCoding,NSCopying>

/** Initialize a new instance from JSON object as a NSDictionary */
- (id)initWithDictionary:(NSDictionary *)dictionary;
/**
 JSON object as a NSDictionary to post to API
 @returns The NSDictionary
 */
- (NSDictionary *)dictionary;

@end
