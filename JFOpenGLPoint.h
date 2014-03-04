//
// JFOpenGLPoint.h
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

// NOTE: Be sure to include OpenGL.framework in your project!
#import <Foundation/Foundation.h>
#import <math.h>

#import "JFOpenGLVertex.h"

/*
 * Point class for maintaining original, calculated, and final 2D render points.
 * Optimized for reusing values when possible.
 */
@interface JFOpenGLPoint : NSObject {
	
	// The original vertex.
	JFOpenGLVertex *_originalVertex;
	
	// The calculated vertex relative to some reference point.
	JFOpenGLVertex *_calculatedVertex;
	
	// The renderable vertex on screen.
	JFOpenGLVertex *_renderVertex;
}

#pragma mark - Properties

#if !__has_feature(objc_arc)
	@property (nonatomic, retain) JFOpenGLVertex *originalVertex;
	@property (nonatomic, retain) JFOpenGLVertex *calculatedVertex;
	@property (nonatomic, retain) JFOpenGLVertex *renderVertex;
#else
	@property (nonatomic, strong) JFOpenGLVertex *originalVertex;
	@property (nonatomic, strong) JFOpenGLVertex *calculatedVertex;
	@property (nonatomic, strong) JFOpenGLVertex *renderVertex;
#endif


+ (id) point;

- (void) mirrorInto: (JFOpenGLPoint *) point;


@end
