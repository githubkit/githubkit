//
//  GHKObject.h
//  GitHubKit
//
//  Created by Atsushi Nagase on 4/11/12.
//  Copyright (c) 2012 LittleApps Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GHKObject <NSObject,NSCoding,NSCopying>

- (id)initWithDictionary:(NSDictionary *)dictionary;
- (NSDictionary *)dictionary;

@end
