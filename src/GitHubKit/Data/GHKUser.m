//
//  GHKUser.m
//  GitHubKit
//
//  Created by Atsushi Nagase on 4/2/12.
//  Copyright (c) 2012 LittleApps Inc. All rights reserved.
//

#import "GHKUser.h"

@implementation GHKUser

@synthesize avatarUrl = _avatarUrl;
@synthesize gravatarId = _gravatarId;
@synthesize login = _login;
@synthesize url = _url;
@synthesize userId = _userId;


- (id)initWithDictionary:(NSDictionary *)dictionary {
  if(self=[self init]) {
    self.avatarUrl = [NSURL URLWithString:[dictionary valueForKey:@"avatar_url"]];
    self.gravatarId = [dictionary valueForKey:@"gravatar_id"];
    self.login = [dictionary valueForKey:@"login"];
    self.url = [NSURL URLWithString:[dictionary valueForKey:@"url"]];
    self.userId = [[dictionary valueForKey:@"id"] integerValue];
  }
  return self;
}

- (NSDictionary *)dictionary {
  return [NSDictionary dictionaryWithObjectsAndKeys:
          [NSNumber numberWithInteger:self.userId], @"id",
          self.avatarUrl.absoluteString, @"avatar_url",
          self.gravatarId, @"gravatar_id",
          self.login, @"login",
          self.url.absoluteString, @"url",
          nil];
}

#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)aCoder {
  [aCoder encodeInteger:self.userId forKey:@"id"];
  [aCoder encodeObject:self.avatarUrl forKey:@"avatar_url"];
  [aCoder encodeObject:self.gravatarId forKey:@"gravatar_id"];
  [aCoder encodeObject:self.login forKey:@"login"];
  [aCoder encodeObject:self.url forKey:@"url"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
  GHKUser *user = [[GHKUser alloc] init];
  user.avatarUrl = [aDecoder decodeObjectForKey:@"avatar_url"];
  user.gravatarId = [aDecoder decodeObjectForKey:@"gravatar_id"];
  user.login = [aDecoder decodeObjectForKey:@"login"];
  user.url = [aDecoder decodeObjectForKey:@"url"];
  user.userId = [aDecoder decodeIntegerForKey:@"id"];
  return user;
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
  GHKUser *user = [[GHKUser alloc] init];
  user.avatarUrl = self.avatarUrl.copy;
  user.gravatarId = self.gravatarId.copy;
  user.login = self.login.copy;
  user.url = self.url.copy;
  user.userId = self.userId;
  return user;
}



@end
