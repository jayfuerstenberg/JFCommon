//
// JFPropertyAnimationAdvancementArray.m
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

#import "JFPropertyAnimationAdvancementArray.h"

@implementation JFPropertyAnimationAdvancementArray


#pragma mark - Properties

@synthesize count = _count;


#pragma mark - Object lifecycle methods

+ (id) advancementArrayWithElementCount: (NSUInteger) count {
	
	if (count == 0) {
		return nil;
	}
	
	id array = [[JFPropertyAnimationAdvancementArray alloc] initWithElementCount: count];
    #if !__has_feature(objc_arc)
        [array autorelease];
    #endif
	
	return array;
}


- (id) init {
	
    #if !__has_feature(objc_arc)
        [self release];
    #endif
    
	return nil;
}


- (id) initWithElementCount: (NSUInteger) count {
	
	if (count == 0) {
        #if !__has_feature(objc_arc)
            [self release];
        #endif
		return nil;
	}
	
	self = [super init];
	if (self != nil) {
		_innerArray = malloc(sizeof(CGFloat) * count);
		_count = count;
	}
	
	return self;
}


- (void) dealloc {
	
	free(_innerArray);
	_innerArray = NULL;
	
    #if !__has_feature(objc_arc)
        [super dealloc];
    #endif
}


#pragma mark - Getter / setter methods

- (CGFloat) valueAtIndex: (NSUInteger) index {
	
	if (index >= _count) {
		return NAN;
	}
	
	return _innerArray[index];
}

- (void) setValue: (CGFloat) value atIndex: (NSUInteger) index {
	
	if (index >= _count) {
		return;
	}
	
	_innerArray[index] = value;
}

@end
