//
//  JFPopularityCache.m
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

#import "JFPopularityCache.h"


@implementation JFPopularityCache


#pragma mark - Properties

@synthesize cache = _cache;


#pragma mark - Object lifecycle methods

/*
 * Initializes the cache.
 *
 * Return
 *		The instance.
 */
- (id) init {
	
	self = [super init];
	
	_cache = [[NSMutableDictionary alloc] initWithCapacity: JFPopularityCacheDefaultMaxCapacity];
	_popularity = [[NSMutableArray alloc] initWithCapacity: JFPopularityCacheDefaultMaxCapacity];
	_maxCapacity = JFPopularityCacheDefaultMaxCapacity;
	
	return self;
}

#if  __has_feature(objc_arc)

#else

- (void) dealloc {
	
	[_cache release];
	[_popularity release];
	[super dealloc];
}

#endif


#pragma mark - Methods

- (void) setMaxCapacity: (NSUInteger) maxCapacity {
	
	if (maxCapacity < 1) {
		return;
	}
	
	NSUInteger objectCount = [self objectCount];
	if (maxCapacity < objectCount) {
		/*
		 * The max capacity just shrunk below what the current object count.
		 * Kick out the excessive objects.
		 */
		for (NSUInteger loop = 0; loop < (objectCount - maxCapacity); loop++) {
			[self removeLastObject];
		}
	}
	
	_maxCapacity = maxCapacity;
}

- (NSUInteger) maxCapacity {
	
	return _maxCapacity;
}

- (NSUInteger) objectCount {
	
	NSUInteger count;
	@synchronized (_cache) {
		count = [_cache count];
	}
	
	return count;
}

- (void) clear {
	
	@synchronized (_cache) {
		@synchronized (_popularity) {
			[_cache removeAllObjects];
			[_popularity removeAllObjects];
		}
	}
}

- (id) addObject: (id) object withKey: (NSString *) key {
	
	if (object == nil) {
		return nil;
	}
	
	if ([key length] == 0) {
		return nil;
	}
	
	if (![self containsObject: object]) {
		// The object does not exist in the cache so add it...
		@synchronized (_cache) {
			@synchronized (_popularity) {
				[_cache setObject: object
						   forKey: key];
				[_popularity insertObject: object
								  atIndex: 0];
                
                if ([object conformsToProtocol: @protocol(JFPopularityCacheable)]) {
                    if ([object respondsToSelector: @selector(wasAddedToPopularityCache:)]) {
                        [object wasAddedToPopularityCache: self];
                    }
                }
			}
		}
	} else {
		// The object is in the cache so just reorder the popularity.
		@synchronized (_popularity) {
			NSUInteger index = [_popularity indexOfObject: object];
            if (index != INT_MAX) {
                [_popularity removeObjectAtIndex: index];
            }
			
			[_popularity insertObject: object
							  atIndex: 0];
		}
	}
	
	NSUInteger objectCount = [self objectCount];
	if (objectCount > _maxCapacity) {
		// There is one too many objects in the cache so remove the last one.
		[self removeLastObject];
	}
	
	return object;
}

- (id) removeObjectWithKey: (NSString *) key {
	
	if ([key length] == 0) {
		return nil;
	}
	
	id object;
	
	// Return the element if it exists.
	@synchronized (_cache) {
		object = [_cache objectForKey: key];
	}
	
	if (object == nil) {
		return nil;
	}
	
	// The object will be removed now.
	@synchronized (_popularity) {
		NSUInteger index = [_popularity indexOfObject: object];
		[_popularity removeObjectAtIndex: index];
		NSArray *allKeys = [_cache allKeysForObject: object];
		[_cache removeObjectsForKeys: allKeys];
        
        [object retain];
        if ([object conformsToProtocol: @protocol(JFPopularityCacheable)]) {
            if ([object respondsToSelector: @selector(wasRemovedFromPopularityCache:)]) {
                [object wasRemovedFromPopularityCache: self];
            }
        }
        [object release];
	}

	return object;
}

- (id) removeLastObject {
	
	if ([self objectCount] == 0) {
		return nil;
	}
	
	id <NSObject> object = nil;
	@synchronized (_popularity) {
		@synchronized (_cache) {
			object = [_popularity lastObject];
            [object retain];
			NSArray *allKeys = [_cache allKeysForObject: object];
			[_popularity removeLastObject];
			[_cache removeObjectsForKeys: allKeys];
            
            if ([object conformsToProtocol: @protocol(JFPopularityCacheable)]) {
                if ([object respondsToSelector: @selector(wasRemovedFromPopularityCache:)]) {
                    [object performSelector: @selector(wasRemovedFromPopularityCache:)
                                 withObject: self];
                }
            }
            [object release];
        }
	}
	
	return object;
}

- (BOOL) containsObject: (id) object {
	
	if (object == nil) {
		return NO;
	}
	
	BOOL contained;
	
	// Delegate the call to the popularity array.
	@synchronized (_popularity) {
		contained = [_popularity containsObject: object];
	}
	
	return contained;
}

- (id) objectWithKey: (NSString *) key {
	
	id object;
	
	// Return the element if it exists.
	@synchronized (_cache) {
		object = [_cache objectForKey: key];
	}
	
	if (object == nil) {
		return nil;
	}
	
	return object;
}

@end