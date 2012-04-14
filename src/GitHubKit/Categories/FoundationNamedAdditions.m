//
//  FoundationNamedAdditions.m
//
//  Created by Atsushi Nagase on 5/11/11.
//  Copyright 2011 LittleApps Inc. All rights reserved.
//

#import "FoundationNamedAdditions.h"

@implementation NSArray (NamedAddition)

+ (NSArray *)arrayNamed:(NSString *)name {
  return [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForNamedAsset:name]];
}

@end

@implementation NSDictionary (NamedAddition)

+ (NSDictionary *)dictionaryNamed:(NSString *)name {
  return [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForNamedAsset:name]];
}

@end

@implementation NSString (NamedAddition)

+ (NSString *)stringNamed:(NSString *)name {
  NSError *error = nil;
  NSStringEncoding encoding;
  NSString *ret = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForNamedAsset:name]
                                        usedEncoding:&encoding
                                               error:&error];
  if(error) NSLog(@"%@", error);
  return ret;
}

@end

@implementation NSBundle (NamedAddition)

- (NSString *)pathForNamedAsset:(NSString *)name {
  NSMutableArray *ar = [[name componentsSeparatedByString:@"."] mutableCopy];
  NSString *ext = @"plist";
  if([ar count]>=2) {
    ext = [ar lastObject];
    [ar removeLastObject];
  }
  name = [ar componentsJoinedByString:@"."];
  return [self pathForResource:name ofType:ext];
}

@end
