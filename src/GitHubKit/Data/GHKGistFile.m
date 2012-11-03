//
//  GHKGistFile.m
//  GitHubKit
//
//  Created by Atsushi Nagase on 4/2/12.
//  Copyright (c) 2012 LittleApps Inc. All rights reserved.
//

#import "GHKGistFile.h"
#import "TTGlobalCore.h"

#define MARKDOWN_EXTENSIONS @[@".markdown@", @"mdown", @"mkdn", @"md", @"mkd", @"mdwn", @"mdtxt", @"mdtext", @"text"]

@implementation GHKGistFile

#pragma mark -

- (NSDictionary *)dictionary {
  return [NSDictionary dictionaryWithObjectsAndKeys:
          [NSNumber numberWithInteger:self.size], @"size",
          self.filename, @"filename",
          self.language, @"language",
          self.rawUrl.absoluteString, @"raw_url",
          nil];
}

- (BOOL)hasChanges {
  return self.backup &&
  !(
    [self.content isEqualToString:self.backup.content] &&
    [self.filename isEqualToString:self.backup.filename]
    );
}

- (BOOL)isMarkdown {
  return [MARKDOWN_EXTENSIONS containsObject:self.rawUrl.pathExtension];
}

- (NSComparisonResult)compare:(GHKGistFile *)other {
  if([other isKindOfClass:[GHKGistFile class]]) {
    if(other.isMarkdown && !self.isMarkdown)
      return NSOrderedDescending;
    return [self.filename compare:other.filename];
  }
  return NSOrderedSame;
}

#pragma mark - initializers

- (id)init {
  if(self=[super init]) {
    self.content = @"";
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
}

#pragma mark - NSObject

- (BOOL)isEqual:(id)object {
  if([object isKindOfClass:[GHKGistFile class]]) {
    return [((GHKGistFile *)object).filename isEqualToString:self.filename];
  }
  return NO;
}

- (NSString *)description {
  return [NSString stringWithFormat:@"<%@: %@>", NSStringFromClass(self.class), self.filename];
}

#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)aCoder {
  [aCoder encodeInteger:self.size forKey:@"size"];
  [aCoder encodeObject:self.content forKey:@"content"];
  [aCoder encodeObject:self.filename forKey:@"filename"];
  [aCoder encodeObject:self.language forKey:@"language"];
  [aCoder encodeObject:self.rawUrl forKey:@"raw_url"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
  GHKGistFile *file = [[GHKGistFile alloc] init];
  file.content = [aDecoder decodeObjectForKey:@"content"];
  file.filename = [aDecoder decodeObjectForKey:@"filename"];
  file.language = [aDecoder decodeObjectForKey:@"language"];
  file.rawUrl = [aDecoder decodeObjectForKey:@"raw_url"];
  file.size = [aDecoder decodeIntegerForKey:@"size"];
  return file;
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
  GHKGistFile *file = [[GHKGistFile alloc] init];
  file.content = self.content.copy;
  file.filename = self.filename.copy;
  file.language = self.language.copy;
  file.rawUrl = self.rawUrl.copy;
  file.size = self.size;
  return file;
}

@end
