//
//  FoundationNamedAdditions.h
//
//  Created by Atsushi Nagase on 5/11/11.
//  Copyright 2011 LittleApps Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (NamedAddition)
+ (NSArray *)arrayNamed:(NSString *)name;
@end

@interface NSDictionary (NamedAddition)
+ (NSDictionary *)dictionaryNamed:(NSString *)name;
@end

@interface NSBundle (NamedAddition)
- (NSString *)pathForNamedAsset:(NSString *)name;
@end

@interface NSString (NamedAddition)
+ (NSString *)stringNamed:(NSString *)name;
@end