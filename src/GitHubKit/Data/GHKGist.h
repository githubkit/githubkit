//
//  GHKGist.h
//  GitHubKit
//
//  Created by Atsushi Nagase on 4/2/12.
//  Copyright (c) 2012 LittleApps Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GitHubKit/GHKObject.h"

@class GHKUser, GHKGistFile;
/** A class describes a gist */
@interface GHKGist : NSObject<GHKObject>

/** Is the gist public */
@property (nonatomic) BOOL isPublic;
/** Is the gist starred */
@property (nonatomic) BOOL isStarred;
/** Number of comments */
@property (nonatomic) NSInteger comments;
/** The user who wrote the gist */
@property (nonatomic,strong) GHKUser *user;
/** Date created at */
@property (nonatomic,strong) NSDate *createdAt;
/** Date updated at */
@property (nonatomic,strong) NSDate *updatedAt;
/** Array of deleted GHKGistFile while editing */
@property (nonatomic,strong) NSMutableArray *deletedFiles;
/** Array of GHKGistFile */
@property (nonatomic,strong) NSMutableArray *files;
/** Description of gist */
@property (nonatomic,strong) NSString *gistDescription;
/** Gist ID */
@property (nonatomic,strong) NSString *gistId;
/** Git Pull URL */
@property (nonatomic,strong) NSURL *gitPullUrl;
/** Git Push URL */
@property (nonatomic,strong) NSURL *gitPushUrl;
/** HTML URL */
@property (nonatomic,strong) NSURL *htmlUrl;
/** Single gist API URL */
@property (nonatomic,strong) NSURL *url;
/** Is the gist stored on the web */
@property (nonatomic,readonly) BOOL isNew;

///---------------------------------------------------------------------------------------
/// @name Initialization
///---------------------------------------------------------------------------------------

/** Initialize new empty gist */
 - (id)initEmpty;

///---------------------------------------------------------------------------------------
/// @name File manipulation
///---------------------------------------------------------------------------------------

/** Creates an empty file and adds to files
 @returns the file created
 */
- (GHKGistFile *)addEmptyFile;
/** Creates an empty file without adding
 @returns the file created
 */
- (GHKGistFile *)createEmptyFile;
/** Delete the file */
- (void)deleteFile:(GHKGistFile *)file;
/** Find a file by filename
 @returns the file found
 */
- (GHKGistFile *)fileWithFilename:(NSString *)filename;

@end
