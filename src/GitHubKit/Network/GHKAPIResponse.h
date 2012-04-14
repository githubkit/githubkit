//
//  GHKAPIResponse.h
//  GitHubKit
//
//  Created by Atsushi Nagase on 4/12/12.
//  Copyright (c) 2012 LittleApps Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

/** API response class */
@interface GHKAPIResponse : NSObject {
  NSInteger _cursor;
  __strong NSMutableArray *_items;
}

/**  */
@property (nonatomic) BOOL success;
/**  */
@property (nonatomic, strong) Class itemClass;
/**  */
@property (nonatomic, strong) NSURL *nextURL;
/**  */
@property (nonatomic, strong) NSURL *prevURL;
/**  */
@property (nonatomic, strong) NSURL *firstURL;
/**  */
@property (nonatomic, strong) NSURL *lastURL;
/**  */
@property (nonatomic, strong) NSHTTPURLResponse *httpResponse;
/**  */
@property (nonatomic, strong) NSError *error;


/**  */
- (id)first;
/**  */
- (id)next;
/**  */
- (void)reset;
/**  */
- (NSArray *)all;
/**  */
- (void)processResponse:(NSURLResponse *)response data:(NSData *)data error:(NSError *)error;
/**  */
- (NSDictionary *)parseLinkHeader:(NSString *)headerField;

@end
