//
//  JFPopularityCacheable.h
//  JFCommon
//
//  Created by Jay Fuerstenberg on 2014/07/23.
//  Copyright 2014 Jason Fuerstenberg. All rights reserved.
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
//

#import <Foundation/Foundation.h>

@class JFPopularityCache;

/*
 * The protocol to which LRU cacheable objects
 * should adhere if they want to be notified of
 * their addition and removal from popularity caches.
 *
 * While not strictly necessary for use with the
 * JFPopularityCache class, knowing of their use
 * within the cache can help them better manage
 * their resources.
 */
@protocol JFPopularityCacheable <NSObject>

@optional

/*
 * The method called when the JFPopularityCacheable implementing object is
 * added to a JFPopularityCache.
 */
- (void) wasAddedToPopularityCache: (JFPopularityCache *) popularityCache;

/*
 * The method called when the JFPopularityCacheable implementing object is
 * removed from a JFPopularityCache.
 */
- (void) wasRemovedFromPopularityCache: (JFPopularityCache *) popularityCache;

@end
