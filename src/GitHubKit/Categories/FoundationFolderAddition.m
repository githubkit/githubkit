//
//  FoundationFolderAddition.m
//  GitHubKit
//
//  Created by Atsushi Nagase on 2/19/12.
//  Copyright (c) 2012 LittleApps Inc. All rights reserved.
//

#import "FoundationFolderAddition.h"
#import "NSDateAdditions.h"

NSString *kIMFFolderDateFormat = @"yyyyMMdd-HHmmss";

@implementation NSDateFormatter (folder)

+ (id)folderDateFormatter {
  static NSDateFormatter *_folderDateFormatter;
  if(nil==_folderDateFormatter) {
    _folderDateFormatter = [[NSDateFormatter alloc] init];
    [_folderDateFormatter setDateFormat:kIMFFolderDateFormat];
  }
  return _folderDateFormatter; 
}

@end


@implementation NSDate (folder)

- (NSString *)folderName {
  return [[NSDateFormatter folderDateFormatter] stringFromDate:self];
}

@end

@implementation NSString (folder)

- (NSString *)filename {
  NSURL *URL = [NSURL URLWithString:self];
  NSDate *date = [self folderDate];
  return date && [date isKindOfClass:[NSDate class]] ?
  [date formatDate] : [URL lastPathComponent];
}

- (NSDate *)folderDate {
  NSURL *URL = [NSURL URLWithString:self];
  return [[NSDateFormatter folderDateFormatter] dateFromString:[URL lastPathComponent]];
}

@end
