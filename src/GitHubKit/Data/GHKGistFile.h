//
//  GHKGistFile.h
//  GitHubKit
//
//  Created by Atsushi Nagase on 4/2/12.
//  Copyright (c) 2012 LittleApps Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GitHubKit/GHKObject.h"

@class GHKGist;
@interface GHKGistFile : NSObject<GHKObject>

@property (nonatomic) NSInteger size;
@property (nonatomic,strong) GHKGist *gist;
@property (nonatomic,strong) GHKGistFile *backup;
@property (nonatomic,strong) NSString *content;
@property (nonatomic,strong) NSString *filename;
@property (nonatomic,strong) NSString *language;
@property (nonatomic,strong) NSString *type;
@property (nonatomic,strong) NSURL *rawUrl;

- (BOOL)hasChanges;
- (GHKGistFile *)createBackup;
- (id)initWithDictionary:(NSDictionary *)dictionary gist:(GHKGist *)gist;
- (id)initWithGist:(GHKGist *)gist;
- (void)discardChanges;

@end
