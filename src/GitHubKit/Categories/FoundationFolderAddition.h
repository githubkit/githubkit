//
//  FoundationFolderAddition.h
//  GitHubKit
//
//  Created by Atsushi Nagase on 2/19/12.
//  Copyright (c) 2012 LittleApps Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *kIMFFolderDateFormat;

@interface NSDateFormatter (folder)

+ (id)folderDateFormatter;

@end

@interface NSDate (folder)

- (NSString *)folderName;

@end


@interface NSString (foldar)

- (NSString *)filename;
- (NSDate *)folderDate;
  
@end