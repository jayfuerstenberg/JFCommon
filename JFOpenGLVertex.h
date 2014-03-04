//
// JFOpenGLVertex.h
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

// NOTE: Be sure to include OpenGL.framework in your project!
#import <Foundation/Foundation.h>
#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR
	#import <OpenGLES/EAGL.h>
	#import <OpenGLES/ES1/gl.h>
	#import <OpenGLES/ES1/glext.h>
#elif TARGET_OS_MAC
	#import <OpenGL/gl.h>
	#import <OpenGL/glu.h>
	#import <OpenGL/CGLTypes.h>
#endif
#import <math.h>


/*
 * A vertex for rendering points, lines, quads.
 */
@interface JFOpenGLVertex : NSObject {
    
    // NOTE: For optimization reasons going with a C-struct style of public access.
@public
    // Coordinates
    GLfloat _x;
	GLfloat _y;
	GLfloat _z;
	
    // Color components
	GLfloat _red;
	GLfloat _green;
	GLfloat _blue;
	GLfloat _alpha;
	
    // Texture coordinates
	GLfloat _u;
	GLfloat _v;
}

#pragma mark - Object lifecycle methods

+ (id) vertex;
+ (id) vertexWithX: (GLfloat) x y: (GLfloat) y z: (GLfloat) z;
- (id) initWithX: (GLfloat) x y: (GLfloat) y z: (GLfloat) z;


#pragma mark - Getter / setter methods

- (void) setRed: (GLfloat) red green: (GLfloat) green blue: (GLfloat) blue;
- (void) setAlpha: (GLfloat) alpha;
- (GLfloat) alpha;
- (void) setU: (GLfloat) u v: (GLfloat) v;


#pragma mark - Other methods

- (void) mirrorXyzOf: (JFOpenGLVertex *) source;
- (void) mirrorUvOf: (JFOpenGLVertex *) source;
- (void) mirror: (JFOpenGLVertex *) source;
- (void) setRelativeToVertex: (JFOpenGLVertex *) vertex;
- (void) setRelativeToX: (GLfloat) x y: (GLfloat) y z: (GLfloat) z;
+ (BOOL) isReferencePoint: (JFOpenGLVertex *) a equalTo: (JFOpenGLVertex *) b;


#pragma mark - Calculation methods

- (GLfloat) distanceTo: (JFOpenGLVertex *) other;

@end
