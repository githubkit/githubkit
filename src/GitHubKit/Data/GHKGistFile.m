//
//  GHKGistFile.m
//  GitHubKit
//
//  Created by Atsushi Nagase on 4/2/12.
//  Copyright (c) 2012 LittleApps Inc. All rights reserved.
//

#import "GHKGistFile.h"
#import "TTGlobalCore.h"

@implementation GHKGistFile

@synthesize backup = _backup;
@synthesize content = _content;
@synthesize filename = _filename;
@synthesize gist = _gist;
@synthesize language = _language;
@synthesize rawUrl = _rawUrl;
@synthesize size = _size;
@synthesize type = _type;

#pragma mark -

- (NSDictionary *)dictionary {
  return [NSDictionary dictionaryWithObjectsAndKeys:
          [NSNumber numberWithInteger:self.size], @"size",
          self.filename, @"filename",
          self.language, @"language",
          self.rawUrl.absoluteString, @"raw_url",
          self.type, @"type",
          nil];
}

- (BOOL)hasChanges {
  return self.backup &&
  !(
    [self.content isEqualToString:self.backup.content] &&
    [self.filename isEqualToString:self.backup.filename]
    );
}

#pragma mark - initializers

- (id)init {
  if(self=[super init]) {
    self.content = @"";
  }
  return self;
}

- (id)initWithGist:(GHKGist *)gist {
  if(self=[self init]) {
    self.gist = gist;
  }
  return self;
}

- (id)initWithDictionary:(NSDictionary *)dictionary gist:(GHKGist *)gist {
  if(self=[self initWithDictionary:dictionary]) {
    self.gist = gist;
  }
  return self;
}

- (id)initWithDictionary:(NSDictionary *)dictionary {
  if(self=[self init]) {
    self.content = [dictionary valueForKey:@"content"];
    self.filename = [dictionary valueForKey:@"filename"];
    self.language = TTIsStringWithAnyText([dictionary valueForKey:@"language"]) ? [dictionary valueForKey:@"language"] : @"";
    self.rawUrl = [NSURL URLWithString:[dictionary valueForKey:@"raw_url"]];
    self.size = [[dictionary valueForKey:@"size"] integerValue];
    self.type = [dictionary valueForKey:@"type"];
  }
  return self;
}

#pragma mark - editing

- (GHKGistFile *)createBackup {
  return self.backup = [self copy];
}

- (void)discardChanges {
  self.content = self.backup.content;
  self.filename = self.backup.filename;
  self.language = self.backup.language;
  self.rawUrl = self.backup.rawUrl;
  self.size = self.backup.size;
  self.type = self.backup.type;
}

#pragma mark - NSObject

- (BOOL)isEqual:(id)object {
  if([object isKindOfClass:[GHKGistFile class]]) {
    return [((GHKGistFile *)object).filename isEqualToString:self.filename];
  }
  return NO;
}

#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)aCoder {
  [aCoder encodeInteger:self.size forKey:@"size"];
  [aCoder encodeObject:self.content forKey:@"content"];
  [aCoder encodeObject:self.filename forKey:@"filename"];
  [aCoder encodeObject:self.language forKey:@"language"];
  [aCoder encodeObject:self.rawUrl forKey:@"raw_url"];
  [aCoder encodeObject:self.type forKey:@"type"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
  GHKGistFile *file = [[GHKGistFile alloc] initWithGist:self.gist];
  file.content = [aDecoder decodeObjectForKey:@"content"];
  file.filename = [aDecoder decodeObjectForKey:@"filename"];
  file.language = [aDecoder decodeObjectForKey:@"language"];
  file.rawUrl = [aDecoder decodeObjectForKey:@"raw_url"];
  file.size = [aDecoder decodeIntegerForKey:@"size"];
  file.type = [aDecoder decodeObjectForKey:@"type"];
  return file;
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
  GHKGistFile *file = [[GHKGistFile alloc] initWithGist:self.gist];
  file.content = self.content.copy;
  file.filename = self.filename.copy;
  file.language = self.language.copy;
  file.rawUrl = self.rawUrl.copy;
  file.size = self.size;
  file.type = self.type.copy;
  return file;
}

@end
