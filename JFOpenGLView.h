//
// JFOpenGLView.h
// JFCommon
//
// Created by Jason Fuerstenberg on 2009/06/22.
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


#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR
    #import <UIKit/UIKit.h>
    #import <GLKit/GLKit.h>
    #import <OpenGLES/EAGL.h>
    #import <OpenGLES/ES1/gl.h>
    #import <OpenGLES/ES1/glext.h>
    #import <OpenGLES/ES2/gl.h>
    #import <OpenGLES/ES2/glext.h>
#elif TARGET_OS_MAC
    #import <Foundation/Foundation.h>
#endif

#import "JFOpenGLUtil.h"
#import "JFOpenGLMatrix.h"
#import "JFOpenGLCamera.h"


#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR


#pragma mark - iOS implementation

/*
 * NOTE: This class is built upon the GLKit stnadard to abstract away
 * the buffer maintenance logic and for easy enabling of anti-aliasing.
 * As such iOS 5.0 is a minimum requirement for using this class.
 * This class can be used with either OpenGL ES 1.1 or 2.0.
 */
@interface JFOpenGLView : GLKView {
    
    NSUInteger _openGlApiVersion;
    
    BOOL _originIsBottomLeft;
	
	EAGLContext *_context;
    
    // OpenGL 2.0 members ----
    GLuint _positionSlot;
    
    GLuint _colorSlot;
    
    GLint _projectionUniform;
    
    GLKBaseEffect *_baseEffect;
}


#pragma mark - Properties

@property (nonatomic, readonly) GLuint positionSlot;
@property (nonatomic, readonly) GLuint colorSlot;
@property (nonatomic, readonly) GLKBaseEffect *baseEffect;


#pragma mark - Object lifecycle methods

- (id) initWithFrame: (CGRect) frameRect openGlApiVersion: (NSUInteger) openGlApiVersion originIsBottomLeft: (BOOL) originIsBottomLeft;


#pragma mark - Action methods

- (void) render;

@end

#elif TARGET_OS_MAC


#pragma mark - OSX implementation

/*
 * This class is based on OpenGL 1.1.
 * OpenGL 2.0+ is not supported as of yet.
 */
@interface JFOpenGLView : NSOpenGLView {
	
    JFOpenGLCamera *_camera;
    
	BOOL _setup;
}


#pragma mark - Properties

@property (nonatomic, retain) JFOpenGLCamera *camera;


#pragma mark - Object lifecycle methods

- (id) initWithFrame: (NSRect) frameRect;

@end

#endif



