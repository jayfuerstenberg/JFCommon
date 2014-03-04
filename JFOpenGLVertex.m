//
// JFOpenGLVertex.m
// JFCommon
//
// Created by Jason Fuerstenberg on 2006/07/12.
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

#import "JFOpenGLVertex.h"

@implementation JFOpenGLVertex


#pragma mark - Object lifecycle methods

+ (id) vertex {
	
	JFOpenGLVertex *vertex = [[JFOpenGLVertex alloc] init];
	#if !__has_feature(objc_arc)
		[vertex autorelease];
	#endif
    
	return vertex;	
}

+ (id) vertexWithX: (GLfloat) x y: (GLfloat) y z: (GLfloat) z {

    JFOpenGLVertex *vertex = [[JFOpenGLVertex alloc] init];
#if !__has_feature(objc_arc)
    [vertex autorelease];
#endif
    
    [vertex setX: x
               y: y
               z: z];
    
	return vertex;
}

- (id) init {
	
	self = [super init];
    if (self != nil) {
        _red = 1.0f;
        _green = 1.0f;
        _blue = 1.0f;
        _alpha = 1.0f;
    }
	
	return self;
}


/*
 * Overloaded constructor.
 */
- (id) initWithX: (GLfloat) x y: (GLfloat) y z: (GLfloat) z {

	self = [super init];
    if (self != nil) {
        [self setX: x
                 y: y
                 z: z];
        
		_red = 1.0f;
		_green = 1.0f;
		_blue = 1.0f;
		_alpha = 1.0f;
    }
	
	return self;
}


#pragma mark - Getter / setter methods

- (void) setX: (GLfloat) x y: (GLfloat) y z: (GLfloat) z {
	
	_x = x;
	_y = y;
	_z = z;
	
}

- (void) setRed: (GLfloat) red green: (GLfloat) green blue: (GLfloat) blue {
    
	_red = red;
	_green = green;
	_blue = blue;
}

- (void) setAlpha: (GLfloat) alpha {
    
	_alpha = alpha;
}

- (GLfloat) alpha {
    
    return _alpha;
}

- (void) setU: (GLfloat) u v: (GLfloat) v {
    
	_u = u;
	_v = v;
}



- (void) mirrorXyzOf: (JFOpenGLVertex *) source {
	
	if (source == nil) {
		_x = 0.0f;
		_y = 0.0f;
		_z = 0.0f;
		
		return;
	}
	
	_x = source->_x;
	_y = source->_y;
	_z = source->_z;
}

- (void) mirrorUvOf: (JFOpenGLVertex *) source {
    
    if (source == nil) {
        _u = 0.0f;
        _v = 0.0f;
        
        return;
    }
    
	_u = source->_u;
	_v = source->_v;
}

- (void) mirror: (JFOpenGLVertex *) source {
	
	if (source == nil) {
		_x = 0.0f;
		_y = 0.0f;
		_z = 0.0f;
		
		_red = 1.0f;
		_green = 1.0f;
		_blue = 1.0f;
		_alpha = 1.0f;
		
		return;
	}
	
	_x = source->_x;
	_y = source->_y;
	_z = source->_z;
	
	_red = source->_red;
	_green = source->_green;
	_blue = source->_blue;
	_alpha = source->_alpha;
}

- (void) setRelativeToVertex: (JFOpenGLVertex *) vertex {
    
	if (vertex == nil) {
		return;
	}
	
	_x -= vertex->_x;
	_y -= vertex->_y;
    _z -= vertex->_z;
}


- (void) setRelativeToX: (GLfloat) x y: (GLfloat) y z: (GLfloat) z {

	_x -= x;
	_y -= y;
    _z -= z;
}


+ (BOOL) isReferencePoint: (JFOpenGLVertex *) a equalTo: (JFOpenGLVertex *) b {
    
	if (a == b) {
		return YES;
	}
	
	if (a == nil) {
		return NO;
	}
	
	if (a->_x != b->_x) {
		return NO;
	}
	
	if (a->_y != b->_y) {
		return NO;
	}
	
	if (a->_z != b->_z) {
		return NO;
	}
	
	return YES;
}


/*
 * Returns the distance from this vertex to the other one.
 */
- (GLfloat) distanceTo: (JFOpenGLVertex *) other {
	
	if (other == nil) {
		// Can't make the comparison.
		return 0.0f;
	}
	
	GLfloat xDiff = self->_x - other->_x;
	GLfloat yDiff = self->_y - other->_y;
    
	if (xDiff < 0.0f) {
		xDiff = -xDiff;
	}
	
	if (yDiff < 0.0f) {
		yDiff = -yDiff;
	}
	
	return sqrt((xDiff * xDiff) + (yDiff * yDiff));
    // TODO: is this good enough for 3D distance calculations if they are all on the same plane?
}


@end
