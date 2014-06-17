//
// JFPropertyAnimationAdvancementArray.h
// JFCommon
//
// Created by Jason Fuerstenberg on 2013/09/17.
// Copyright (c) 2013 Jason Fuerstenberg. All rights reserved.
//
// http://www.jayfuerstenberg.com
// jay@jayfuerstenberg.com
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#import <Foundation/Foundation.h>
#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR
    #import <UIKit/UIKit.h>
#elif TARGET_OS_MAC
    #import <Cocoa/Cocoa.h>
#endif

/*
 * A fixed-sized array of native floating point values.
 * Used for performance reasons (to avoid NSNUmber ⇄ CGFloat conversions).
 */
@interface JFPropertyAnimationAdvancementArray : NSObject {
	
    // The actual array of values.
	CGFloat *_innerArray;
	
    // The element count.
	NSUInteger _count;
}


#pragma mark - Properties

@property (nonatomic, readonly) NSUInteger count;


#pragma mark - Object lifecycle methods

+ (id) advancementArrayWithElementCount: (NSUInteger) count;


#pragma mark - Getter / setter methods

- (CGFloat) valueAtIndex: (NSUInteger) index;
- (void) setValue: (CGFloat) value atIndex: (NSUInteger) index;

@end
