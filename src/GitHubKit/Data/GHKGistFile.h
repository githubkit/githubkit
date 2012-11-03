//
//  GHKGistFile.h
//  GitHubKit
//
//  Created by Atsushi Nagase on 4/2/12.
//  Copyright (c) 2012 LittleApps Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GHKObject.h"

@class GHKGist;
/** A class describes a file in gist */
@interface GHKGistFile : NSObject<GHKObject>

/** Size of the file */
@property (nonatomic) NSInteger size;
/** Copy of the file before editing */
@property (nonatomic,strong) GHKGistFile *backup;
/** Content of the file */
@property (nonatomic,strong) NSString *content;
/** Filename of the file */
@property (nonatomic,strong) NSString *filename;
/** Language of the file */
@property (nonatomic,strong) NSString *language;
/** Raw file URL */
@property (nonatomic,strong) NSURL *rawUrl;
/** Is markdown file */
@property (nonatomic,readonly) BOOL isMarkdown;

///---------------------------------------------------------------------------------------
/// @name Editing
///---------------------------------------------------------------------------------------

/** @returns The file has changes */
- (BOOL)hasChanges;
/**
 Creates a backup
 @returns backup created
 */
- (GHKGistFile *)createBackup;
/**
 Discard changes from backup : content, filename
 */
- (void)discardChanges;

@end
