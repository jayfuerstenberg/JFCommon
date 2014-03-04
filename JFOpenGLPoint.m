//
// JFOpenGLPoint.m
// JFCommon
//
// Created by Jason Fuerstenberg on 2009/06/10.
// Copyright (c) 2009 Jason Fuerstenberg. All rights reserved.
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

#import "JFOpenGLPoint.h"


@implementation JFOpenGLPoint

#pragma mark - Properties

@synthesize originalVertex = _originalVertex;
@synthesize calculatedVertex = _calculatedVertex;
@synthesize renderVertex = _renderVertex;


#pragma mark - Object lifecycle methods

+ (id) point {
	
	id point = [[JFOpenGLPoint alloc] init];
	[point autorelease];
	
	return point;
}

/*
 * Default constructor.
 */
- (id) init {
	
	self = [super init];
    if (self != nil) {
        _originalVertex = [[JFOpenGLVertex alloc] init];
        _calculatedVertex = [[JFOpenGLVertex alloc] init];
        _renderVertex = [[JFOpenGLVertex alloc] init];
    }
	
	return self;
}

- (void) dealloc {
	
	#if __has_feature(objc_arc)
		_renderVertex = nil;
		_calculatedVertex = nil;
		_originalVertex = nil;
	#else
		[_renderVertex release];
		[_calculatedVertex release];
		[_originalVertex release];
		[super dealloc];	
	#endif
    
	
}


#pragma mark - Action methods

- (void) mirrorInto: (JFOpenGLPoint *) point {
	
	[[point originalVertex] mirror: _originalVertex];
	[[point calculatedVertex] mirror: _calculatedVertex];
	[[point renderVertex] mirror: _renderVertex];
	
	[[point originalVertex] mirrorUvOf: _originalVertex];
	[[point calculatedVertex] mirrorUvOf: _calculatedVertex];
	[[point renderVertex] mirrorUvOf: _renderVertex];
}

@end
