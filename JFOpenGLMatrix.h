//
// JFOpenGLMatrix.h
// JFCommon
//
// Created by Jason Fuerstenberg on 2009/06/17.
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

#import "JFOpenGLVertex.h"


/**
 * Class for matrix math operations.
 * 
 * This class is performance-optimized for games and constrained devices.
 * 
 * 1 - No nested objects.
 * 2 - Unrolled member structure (as shown below) to avoid array look-ups.
 * 
 * m00 m01 m02 m03
 * m10 m11 m12 m13
 * m20 m21 m22 m23
 * m30 m31 m32 m33
 */
@interface JFOpenGLMatrix : NSObject {
	
@public
    GLfloat _m00;
	GLfloat _m01;
	GLfloat _m02;
	GLfloat _m03;
	GLfloat _m10;
	GLfloat _m11;
	GLfloat _m12;
	GLfloat _m13;
	GLfloat _m20;
	GLfloat _m21;
	GLfloat _m22;
	GLfloat _m23;
	GLfloat _m30;
	GLfloat _m31;
	GLfloat _m32;
	GLfloat _m33;
}

#pragma mark - Object lifecycle methods

+ (id) matrix;


#pragma mark - Calculation methods

- (void) setZero;
- (void) setIdentity;
- (void) setTranslationX: (GLfloat) x y: (GLfloat) y z: (GLfloat) z;
- (void) setScaleX: (GLfloat) x y: (GLfloat) y z: (GLfloat) z;
- (void) setXAngle: (UInt16) angle;
- (void) setYAngle: (UInt16) angle;
- (void) setZAngle: (UInt16) angle;
- (void) multiplyVertex: (JFOpenGLVertex *) vertex;
- (void) mulitplyVertex: (JFOpenGLVertex *) vertex1 into: (JFOpenGLVertex *) vertex2;
- (void) mergeWith: (JFOpenGLMatrix *) other;
- (BOOL) invert;

#pragma mark - Other methods

- (BOOL) isIdentity;

@end
