//
//  JFPopularityCache.h
//  JFCommon
//
//  Created by Jason Fuerstenberg on 2010/04/26.
//  Copyright 2010 Jason Fuerstenberg. All rights reserved.
//
//	Licensed under the Apache License, Version 2.0 (the "License");
//	you may not use this file except in compliance with the License.
//	You may obtain a copy of the License at
//
//	http://www.apache.org/licenses/LICENSE-2.0
//
//	Unless required by applicable law or agreed to in writing, software
//	distributed under the License is distributed on an "AS IS" BASIS,
//	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//	See the License for the specific language governing permissions and
//	limitations under the License.

#import <Foundation/Foundation.h>

#import "JFPopularityCacheable.h"


// The default max capacity
#define JFPopularityCacheDefaultMaxCapacity		10

/*
 * The popularity cache.
 * Objects fall out of the cache from the rear when the object count exceeds the maximum capacity.
 * Objects that are just added are considered popular and are pushed to the front of the cache.
 */
@interface JFPopularityCache : NSObject {
	
	// The cache's maximum capacity.
	NSUInteger _maxCapacity;
	
	// The inner cache dictionary.
	NSMutableDictionary *_cache;
	
	// The popularity rank.
	NSMutableArray *_popularity;
}


#pragma mark - Properties

@property (nonatomic, readonly) NSDictionary *cache;


#pragma mark - Methods

- (void) setMaxCapacity: (NSUInteger) maxCapacity;
- (NSUInteger) maxCapacity;
- (NSUInteger) objectCount;
- (void) clear;
- (id) addObject: (id) object withKey: (NSString *) key;
- (id) removeObjectWithKey: (NSString *) key;
- (id) removeLastObject;
- (BOOL) containsObject: (id) object;
- (id) objectWithKey: (NSString *) key;

@end