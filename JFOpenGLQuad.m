//
// JFOpenGLQuad.m
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

#import "JFOpenGLQuad.h"

@implementation JFOpenGLQuad


#pragma mark - Properties

@synthesize topLeft = _topLeft;
@synthesize topRight = _topRight;
@synthesize bottomLeft = _bottomLeft;
@synthesize bottomRight = _bottomRight;
@synthesize positionSlot = _positionSlot;
@synthesize colorSlot = _colorSlot;
@synthesize baseEffect = _baseEffect;


#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR

#pragma mark - Object lifecycle methods

+ (id) quadWithOpenGlApiVersion: (NSUInteger) openGlApiVersion {
	
	JFOpenGLQuad *quad = [[JFOpenGLQuad alloc] initWithOpenGlApiVersion: openGlApiVersion];
	[quad autorelease];
	
	return quad;
}

- (id) initWithOpenGlApiVersion: (NSUInteger) openGlApiVersion {

	self = [super init];
    
    _openGlApiVersion = openGlApiVersion;
	
	_topLeft = [[JFOpenGLPoint alloc] init];
	_topRight = [[JFOpenGLPoint alloc] init];
	_bottomLeft = [[JFOpenGLPoint alloc] init];
	_bottomRight = [[JFOpenGLPoint alloc] init];
	
	return self;
}

#elif TARGET_OS_MAC

#pragma mark - Object lifecycle methods

+ (id) quad {
	
	JFOpenGLQuad *quad = [[JFOpenGLQuad alloc] init];
	[quad autorelease];
	
	return quad;
}

- (id) init {
    
	self = [super init];
	
	_topLeft = [[JFOpenGLPoint alloc] init];
	_topRight = [[JFOpenGLPoint alloc] init];
	_bottomLeft = [[JFOpenGLPoint alloc] init];
	_bottomRight = [[JFOpenGLPoint alloc] init];
	
	return self;
}

#endif

- (void) dealloc {

	if (_topLeft != nil) {
		[_topLeft release];
		_topLeft = nil;
	}
	
	if (_topRight != nil) {
		[_topRight release];
		_topRight = nil;
	}
	
	if (_bottomLeft != nil) {
		[_bottomLeft release];
		_bottomLeft = nil;
	}
	
	if (_bottomRight != nil) {
		[_bottomRight release];
		_bottomRight = nil;
	}
    
    if (_baseEffect != nil) {
        [_baseEffect release];
    }
	
	[super dealloc];
}


#pragma mark - JFOpenGLPositionable implmentaton methods

- (JFOpenGLVertex *) referencePoint {
    
    return _referencePoint;
}

- (void) setReferencePoint: (JFOpenGLVertex *) referencePoint {
    
    JFAssign(_referencePoint, referencePoint);
}

- (JFOpenGLVertex *) transformReferencePoint {
    
    return _transformReferencePoint;
}

- (void) setTransformReferencePoint: (JFOpenGLVertex *) transformReferencePoint {
    
    JFAssign(_transformReferencePoint, transformReferencePoint);
}

- (JFOpenGLMatrix *) transformMatrix {
    
    return _transformMatrix;
}

- (void) setTransformMatrix: (JFOpenGLMatrix *) transformMatrix {
    
    JFAssign(_transformMatrix, transformMatrix);
}

- (BOOL) shouldUpdateTransformMatrix {
    
    return _shouldUpdateTransformMatrix;
}

- (void) setShouldUpdateTransformMatrix: (BOOL) shouldUpdateTransformMatrix {
    
    _shouldUpdateTransformMatrix = shouldUpdateTransformMatrix;
}

/*
 * Mirrors the contents of source into this quad.
 */
- (void) mirror: (JFOpenGLQuad *) source {

	if (source == nil) {
		return;
	}
    
    [[source topLeft] mirrorInto: _topLeft];
    [[source topRight] mirrorInto: _topRight];
    [[source bottomLeft] mirrorInto: _bottomLeft];
    [[source bottomRight] mirrorInto: _bottomRight];
}


- (void) advance {
    // NOTE: Implement this method in child class if it needs to advance its state.
}


#pragma mark - JFOpenGLRenderable implementaton methods

/*
 * Transforms the original points to those relative to the provided camera for later rendering.
 */
- (void) transformWithCamera: (JFOpenGLCamera *) camera {
    
    _shouldBeRendered = YES;//![JFOpenGLUtil isPositionable: self outOf2DViewWithCamera: camera];
    if (!_shouldBeRendered) {
        return;
    }
	
	[self transformPoint: _topLeft
              withCamera: camera];
	[self transformPoint: _topRight
              withCamera: camera];
	[self transformPoint: _bottomLeft
              withCamera: camera];
	[self transformPoint: _bottomRight
              withCamera: camera];
}

- (void) transformPoint: (JFOpenGLPoint *) point withCamera: (JFOpenGLCamera *) camera {
	
	JFOpenGLVertex *mirror = [point calculatedVertex];
	JFOpenGLVertex *render = [point renderVertex];
	
	// TODO: Would like to only do this if there was a change --- BEGIN
	[mirror mirror: [point originalVertex]];
    
    [self offsetVertex: mirror byReferencePoint: _referencePoint];
	
	// Apply the world transform against the annotation (not sure if there ever are any though)
	[_transformMatrix multiplyVertex: mirror];
    
    [[camera transformMatrix] multiplyVertex: mirror];
	
	[render mirror: mirror];
	// TODO: Would like to only do this if there was a change --- END
    
	[camera transformVertex: render];
}

- (void) offsetVertex: (JFOpenGLVertex *) vertex byReferencePoint: (JFOpenGLVertex *) referencePoint {
    
    if (referencePoint == nil) {
        return;
    }
    
    [vertex setRelativeToX: -referencePoint->_x
                         y: -referencePoint->_y
                         z: -referencePoint->_z];
}


#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR

/*
 * Performs the actual OpenGL ES instructions to render.
 */
- (void) render {
    
    if (!_shouldBeRendered) {
        return;
    }
    
    if (_openGlApiVersion == 1) {
        
        GLfloat quad[12];
        quad[0] = [_topLeft renderVertex]->_x;
        quad[1] = [_topLeft renderVertex]->_y;
        quad[2] = [_topLeft renderVertex]->_z;
        quad[3] = [_topRight renderVertex]->_x;
        quad[4] = [_topRight renderVertex]->_y;
        quad[5] = [_topRight renderVertex]->_z;
        quad[6] = [_bottomLeft renderVertex]->_x;
        quad[7] = [_bottomLeft renderVertex]->_y;
        quad[8] = [_bottomLeft renderVertex]->_z;
        quad[9] = [_bottomRight renderVertex]->_x;
        quad[10] = [_bottomRight renderVertex]->_y;
        quad[11] = [_bottomRight renderVertex]->_z;
        
        GLfloat colors[16];
        colors[0] = [_topLeft originalVertex]->_red;
        colors[1] = [_topLeft originalVertex]->_green;
        colors[2] = [_topLeft originalVertex]->_blue;
        colors[3] = [_topLeft originalVertex]->_alpha;
        colors[4] = [_topRight originalVertex]->_red;
        colors[5] = [_topRight originalVertex]->_green;
        colors[6] = [_topRight originalVertex]->_blue;
        colors[7] = [_topRight originalVertex]->_alpha;
        colors[8] = [_bottomLeft originalVertex]->_red;
        colors[9] = [_bottomLeft originalVertex]->_green;
        colors[10] = [_bottomLeft originalVertex]->_blue;
        colors[11] = [_bottomLeft originalVertex]->_alpha;
        colors[12] = [_bottomRight originalVertex]->_red;
        colors[13] = [_bottomRight originalVertex]->_green;
        colors[14] = [_bottomRight originalVertex]->_blue;
        colors[15] = [_bottomRight originalVertex]->_alpha;
        
        glEnableClientState(GL_VERTEX_ARRAY);
        glEnableClientState(GL_COLOR_ARRAY);
        glVertexPointer(3, GL_FLOAT, 0, &quad);
        glColorPointer(4, GL_FLOAT, 0, colors);
        glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
        glDisableClientState(GL_COLOR_ARRAY);
        glDisableClientState(GL_VERTEX_ARRAY);
        
    } else if (_openGlApiVersion == 2) {
        
        JFOpenGLC2DPosition positions[4];
        JFOpenGLCRGBAColor colors[4];
        
        positions[0]._x = [_bottomLeft renderVertex]->_x;
        positions[0]._y = [_bottomLeft renderVertex]->_y;
        positions[0]._z = [_bottomLeft renderVertex]->_z;
        positions[1]._x = [_bottomRight renderVertex]->_x;
        positions[1]._y = [_bottomRight renderVertex]->_y;
        positions[1]._z = [_bottomRight renderVertex]->_z;
        positions[2]._x = [_topLeft renderVertex]->_x;
        positions[2]._y = [_topLeft renderVertex]->_y;
        positions[2]._z = [_topLeft renderVertex]->_z;
        positions[3]._x = [_topRight renderVertex]->_x;
        positions[3]._y = [_topRight renderVertex]->_y;
        positions[3]._z = [_topRight renderVertex]->_z;
        
        colors[0]._red = [_bottomLeft originalVertex]->_red;
        colors[0]._green = [_bottomLeft originalVertex]->_green;
        colors[0]._blue = [_bottomLeft originalVertex]->_blue;
        colors[0]._alpha = [_bottomLeft originalVertex]->_alpha;
        colors[1]._red = [_bottomRight originalVertex]->_red;
        colors[1]._green = [_bottomRight originalVertex]->_green;
        colors[1]._blue = [_bottomRight originalVertex]->_blue;
        colors[1]._alpha = [_bottomRight originalVertex]->_alpha;
        colors[2]._red = [_topLeft originalVertex]->_red;
        colors[2]._green = [_topLeft originalVertex]->_green;
        colors[2]._blue = [_topLeft originalVertex]->_blue;
        colors[2]._alpha = [_topLeft originalVertex]->_alpha;
        colors[3]._red = [_topRight originalVertex]->_red;
        colors[3]._green = [_topRight originalVertex]->_green;
        colors[3]._blue = [_topRight originalVertex]->_blue;
        colors[3]._alpha = [_topRight originalVertex]->_alpha;
        
        glEnableVertexAttribArray(GLKVertexAttribPosition);
        glEnableVertexAttribArray(GLKVertexAttribColor);
        glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, 0, (void *) positions);
        glVertexAttribPointer(GLKVertexAttribColor, 4, GL_FLOAT, GL_FALSE, 0, (void *) colors);
        glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
        glDisableVertexAttribArray(GLKVertexAttribColor);
        glDisableVertexAttribArray(GLKVertexAttribPosition);
    }
}

#elif TARGET_OS_MAC

- (void) render {
    // TODO: implement this
}

#endif

@end
