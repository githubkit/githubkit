//
//  GHKGist.m
//  GitHubKit
//
//  Created by Atsushi Nagase on 4/2/12.
//  Copyright (c) 2012 LittleApps Inc. All rights reserved.
//

#import "GHKGitHub.h"
#import "GHKGist.h"
#import "GHKGistFile.h"
#import "GHKUser.h"
#import "NSDate+InternetDateTime.h"
#import "TTGlobalCore.h"

@implementation GHKGist
@synthesize comments = _comments;
@synthesize createdAt = _createdAt;
@synthesize deletedFiles = _deletedFiles;
@synthesize files = _files;
@synthesize gistDescription = _gistDescription;
@synthesize gistId = _gistId;
@synthesize gitPullUrl = _gitPullUrl;
@synthesize gitPushUrl = _gitPushUrl;
@synthesize htmlUrl = _htmlUrl;
@synthesize isPublic = _isPublic;
@synthesize isStarred = _isStarred;
@synthesize updatedAt = _updatedAt;
@synthesize url = _url;
@synthesize user = _user;

- (BOOL)isNew {
  return !TTIsStringWithAnyText(self.gistId);
}

- (NSDictionary *)dictionary {
  NSMutableDictionary *dict = [NSMutableDictionary dictionary];
  if(TTIsStringWithAnyText(self.gistDescription))
    [dict setValue:self.gistDescription forKey:@"description"];
  if(self.isNew)
    [dict setValue:[NSNumber numberWithBool:self.isPublic] forKey:@"public"];
  NSMutableDictionary *buf = [NSMutableDictionary dictionary];
  if(!self.isNew) {
    for (GHKGistFile *file in self.deletedFiles) {
      [buf setObject:[NSNull null] forKey:(file.backup.filename)?file.backup.filename:file.filename];
    }
  }
  for (GHKGistFile *file in self.files) {
    if(self.isNew)
      [buf setObject:[NSDictionary dictionaryWithObject:file.content forKey:@"content"]
              forKey:file.filename];
    else
      [buf setObject:[NSDictionary dictionaryWithObjectsAndKeys:
                      file.filename, @"filename",
                      file.content, @"content",
                      nil]
              forKey:TTIsStringWithAnyText(file.backup.filename)?file.backup.filename:file.filename];
  }
  [dict setObject:buf forKey:@"files"];
  return [NSDictionary dictionaryWithDictionary:dict];
}

#pragma mark -

- (GHKGistFile *)fileWithFilename:(NSString *)filename {
  for (GHKGistFile *file in self.files) {
    if([file.filename isEqualToString:filename])
      return file;
  }
  return nil;
}

- (GHKGistFile *)createEmptyFile {
  NSInteger n = 1;
  NSString *filename = nil;
  do {
    filename = [NSString stringWithFormat:@"Untitled %d.txt", n++];
  } while ([self fileWithFilename:filename]);
  GHKGistFile *file = [[GHKGistFile alloc] initWithGist:self];
  file.filename = filename;
  return file;
}

- (GHKGistFile *)addEmptyFile {
  GHKGistFile *file = [self createEmptyFile];
  [self.files addObject:file];
  return file;
}

#pragma mark - initializers

- (id)initEmpty {
  if(self=[self init]) {
    [self addEmptyFile];
  }
  return self;
}

- (id)initWithDictionary:(NSDictionary *)dictionary {
  if(self=[self init]) {
    self.isPublic = [[dictionary valueForKey:@"public"] boolValue];
    self.comments = [[dictionary valueForKey:@"comments"] integerValue];
    self.user = [[dictionary objectForKey:@"user"] isKindOfClass:[NSDictionary class]] ?
    [[GHKUser alloc] initWithDictionary:[dictionary objectForKey:@"user"]] : nil;
    NSDictionary *fileDic = [dictionary objectForKey:@"files"];
    NSMutableArray *buf = [NSMutableArray array];
    [fileDic enumerateKeysAndObjectsUsingBlock:^(id key, id value, BOOL *stop) {
      [buf addObject:[[GHKGistFile alloc] initWithDictionary:value gist:self]];
    }];
    self.files = buf;
    self.createdAt = [NSDate dateFromRFC3339String:[dictionary valueForKey:@"created_at"]];
    self.updatedAt = [NSDate dateFromRFC3339String:[dictionary valueForKey:@"updated_at"]];
    self.gistDescription = TTIsStringWithAnyText([dictionary valueForKey:@"description"]) ? [dictionary valueForKey:@"description"] : @"";
    self.gistId = [dictionary valueForKey:@"id"];
    self.gitPullUrl = [NSURL URLWithString:[dictionary valueForKey:@"git_pull_url"]];
    self.gitPushUrl = [NSURL URLWithString:[dictionary valueForKey:@"git_push_url"]];
    self.htmlUrl = [NSURL URLWithString:[dictionary valueForKey:@"html_url"]];
    self.url = [NSURL URLWithString:[dictionary valueForKey:@"url"]];
  }
  return self;
}

#pragma mark - NSObject

- (id)init {
  if(self=[super init]) {
    self.files = [NSMutableArray array];
    self.deletedFiles = [NSMutableArray array];
  }
  return self;
}

- (BOOL)isEqual:(id)object {
  return [object isKindOfClass:[GHKGist class]] && [((GHKGist *)object).gistId isEqualToString:self.gistId];
}

#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)aCoder {
  [aCoder encodeBool:self.isPublic forKey:@"public"];
  [aCoder encodeBool:self.isStarred forKey:@"starred"];
  [aCoder encodeInteger:self.comments forKey:@"comments"];
  [aCoder encodeObject:self.user forKey:@"user"];
  [aCoder encodeObject:self.files forKey:@"files"];
  [aCoder encodeObject:self.createdAt forKey:@"created_at"];
  [aCoder encodeObject:self.updatedAt forKey:@"updated_at"];
  [aCoder encodeObject:self.gistDescription forKey:@"description"];
  [aCoder encodeObject:self.gistId forKey:@"id"];
  [aCoder encodeObject:self.gitPullUrl forKey:@"git_pull_url"];
  [aCoder encodeObject:self.gitPushUrl forKey:@"git_push_url"];
  [aCoder encodeObject:self.htmlUrl forKey:@"html_url"];
  [aCoder encodeObject:self.url forKey:@"url"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
  GHKGist *gist = [[GHKGist alloc] init];
  gist.isPublic = [aDecoder decodeBoolForKey:@"public"];
  gist.isStarred = [aDecoder decodeBoolForKey:@"starred"];
  gist.comments = [aDecoder decodeIntegerForKey:@"comments"];
  gist.user = [aDecoder decodeObjectForKey:@"user"];
  gist.files = [aDecoder decodeObjectForKey:@"files"];
  gist.createdAt = [aDecoder decodeObjectForKey:@"created_at"];
  gist.updatedAt = [aDecoder decodeObjectForKey:@"updated_at"];
  gist.gistDescription = [aDecoder decodeObjectForKey:@"description"];
  gist.gistId = [aDecoder decodeObjectForKey:@"id"];
  gist.gitPullUrl = [aDecoder decodeObjectForKey:@"git_pull_url"];
  gist.gitPushUrl = [aDecoder decodeObjectForKey:@"git_push_url"];
  gist.htmlUrl = [aDecoder decodeObjectForKey:@"html_url"];
  gist.url = [aDecoder decodeObjectForKey:@"url"];
  return gist;
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
  GHKGist *gist = [[GHKGist alloc] init];
  gist.isPublic = self.isPublic;
  gist.isStarred = self.isStarred;
  gist.comments = self.comments;
  gist.user = [self.user copyWithZone:zone];
  gist.files = [self.files copyWithZone:zone];
  gist.createdAt = [self.createdAt copyWithZone:zone];
  gist.updatedAt = [self.updatedAt copyWithZone:zone];
  gist.gistDescription = [self.gistDescription copyWithZone:zone];
  gist.gistId = [self.gistId copyWithZone:zone];
  gist.gitPullUrl = [self.gitPullUrl copyWithZone:zone];
  gist.gitPushUrl = [self.gitPushUrl copyWithZone:zone];
  gist.htmlUrl = [self.htmlUrl copyWithZone:zone];
  gist.url = [self.url copyWithZone:zone];
  return gist;
}

#pragma mark -

- (void)deleteFile:(GHKGistFile *)file {
  if([self.files containsObject:file]) {
    [self.files removeObject:file];
    [self.deletedFiles addObject:file];
  }
}

@end
