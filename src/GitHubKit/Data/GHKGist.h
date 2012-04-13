//
//  GHKGist.h
//  GitHubKit
//
//  Created by Atsushi Nagase on 4/2/12.
//  Copyright (c) 2012 LittleApps Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GitHubKit/GHKObject.h"

@class GHKUser;
@class GHKGistFile;
@interface GHKGist : NSObject<GHKObject>

@property (nonatomic) BOOL isPublic;
@property (nonatomic) BOOL isStarred;
@property (nonatomic) NSInteger comments;
@property (nonatomic,strong) GHKUser *user;
@property (nonatomic,strong) NSDate *createdAt;
@property (nonatomic,strong) NSDate *updatedAt;
@property (nonatomic,strong) NSMutableArray *deletedFiles;
@property (nonatomic,strong) NSMutableArray *files;
@property (nonatomic,strong) NSString *gistDescription;
@property (nonatomic,strong) NSString *gistId;
@property (nonatomic,strong) NSURL *gitPullUrl;
@property (nonatomic,strong) NSURL *gitPushUrl;
@property (nonatomic,strong) NSURL *htmlUrl;
@property (nonatomic,strong) NSURL *url;

- (BOOL)isNew;
- (GHKGistFile *)addEmptyFile;
- (GHKGistFile *)createEmptyFile;
- (GHKGistFile *)fileWithFilename:(NSString *)filename;
- (id)initEmpty;
- (void)deleteFile:(GHKGistFile *)file;

@end
