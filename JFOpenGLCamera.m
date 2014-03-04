//
// JFOpenGLCamera.m
// JFCommon
//
// Created by Jason Fuerstenberg on 2006/06/12.
// Copyright (c) 2006 Jason Fuerstenberg. All rights reserved.
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

#import "JFOpenGLCamera.h"


@implementation JFOpenGLCamera

#pragma mark - Properties

@synthesize referencePoint = _referencePoint;
@synthesize transformReferencePoint = _transformReferencePoint;
@synthesize transformMatrix = _transformMatrix;
@synthesize shouldUpdateTransformMatrix = _shouldUpdateTransformMatrix;
@synthesize zoomFactor = _zoomFactor;
@synthesize width = _width;
@synthesize height = _height;


#pragma mark - Object lifecycle methods

- (id) initWithWidth: (GLfloat) width height: (GLfloat) height {
	
	self = [super init];
    if (self != nil) {
        [self setReferencePoint: [JFOpenGLVertex vertex]];
        [self setTransformReferencePoint: _referencePoint];
        [self setTransformMatrix: [JFOpenGLMatrix matrix]];
        
        // The transform matrix has yet to be setup so set it to be updated.
        [self setShouldUpdateTransformMatrix: YES];
        
        [self setWidth: width
                height: height];
        
        _zoomFactor = 1.0f;
    }
	
	[self updateOnScreenCoordinates];
	
	return self;
}


- (void) dealloc {
    
	#if __has_feature(objc_arc)
		_referencePoint = nil;
		_transformReferencePoint = nil;
		_transformMatrix = nil;
	#else
		[_referencePoint release];
		[_transformReferencePoint release];
		[_transformMatrix release];
		[super dealloc];
	#endif
}


#pragma mark - Action methods

- (void) setWidth: (GLfloat) width height: (GLfloat) height {
    
    _width = width;
    _height = height;
    
    _halfWidth = width * 0.5f;
    _halfHeight = height * 0.5f;
}

- (void) updateOnScreenCoordinates {
	
	_leftOnScreenX = _referencePoint->_x - _halfWidth;
	_rightOnScreenX = _referencePoint->_x + _halfWidth;
	_bottomOnScreenY = _referencePoint->_y - _halfHeight;
	_topOnScreenY = _referencePoint->_y + _halfHeight;
}

- (void) transformVertex: (JFOpenGLVertex *) vertex {
	
	if (vertex == nil) {
		return;
	}
	
	vertex->_x -= _referencePoint->_x;
	vertex->_y -= _referencePoint->_y;
    vertex->_z -= _referencePoint->_z;
}


- (void) panLeft: (GLfloat) left {

    _referencePoint->_x -= left;
}

- (void) panRight: (GLfloat) right {

    _referencePoint->_x += right;
}

// Maybe make more utility methods here

@end
