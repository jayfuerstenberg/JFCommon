//
// JFOpenGLQuad.h
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


#import <Foundation/Foundation.h>

#import <GLKit/GLKit.h>

#import "JFGC.h"
#import "JFOpenGLCStructs.h"
#import "JFOpenGLPositionable.h"
#import "JFOpenGLRenderable.h"
#import "JFOpenGLPoint.h"
#import "JFOpenGLCamera.h"
#import "JFOpenGLUtil.h"


/*
 * A 4-point OpenGL renderable object.
 */
@interface JFOpenGLQuad : NSObject <JFOpenGLPositionable, JFOpenGLRenderable> {
    
    NSUInteger _openGlApiVersion;

	JFOpenGLPoint *_topLeft;
	JFOpenGLPoint *_topRight;
	JFOpenGLPoint *_bottomLeft;
	JFOpenGLPoint *_bottomRight;
    
    JFOpenGLMatrix *_transformMatrix;
    
    JFOpenGLVertex *_referencePoint;
    
    JFOpenGLVertex *_transformReferencePoint;

    BOOL _shouldUpdateTransformMatrix;
    
    BOOL _shouldBeRendered;
    
    
    // OpenGL 2.0 members ----
    
    // The position slot (if a vertex shader is used)
    GLuint _positionSlot;
    
    // The color slot (if a vertex shader is used)
    GLuint _colorSlot;
    
    // The application-level base effect (if drawing with GLKit)
    GLKBaseEffect *_baseEffect;
}


#pragma mark - Properties

@property (nonatomic, readonly) JFOpenGLPoint *topLeft;
@property (nonatomic, readonly) JFOpenGLPoint *topRight;
@property (nonatomic, readonly) JFOpenGLPoint *bottomLeft;
@property (nonatomic, readonly) JFOpenGLPoint *bottomRight;
@property (nonatomic, assign) GLuint positionSlot;
@property (nonatomic, assign) GLuint colorSlot;
@property (nonatomic, retain) GLKBaseEffect *baseEffect;


#pragma mark - Object lifecylce methods

+ (id) quadWithOpenGlApiVersion: (NSUInteger) openGlApiVersion;
- (id) initWithOpenGlApiVersion: (NSUInteger) openGlApiVersion;


#pragma mark - Action methods

- (void) mirror: (JFOpenGLPoint *) source;

@end
