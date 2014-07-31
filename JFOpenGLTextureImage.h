//
// JFOpenGLTextureImage.h
// JFCommon
//
// Created by Jason Fuerstenberg on 2009/11/03.
// Copyright 2009 Jason Fuerstenberg. All rights reserved.
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

#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR
    #import <UIKit/UIKit.h>
	#import <OpenGLES/EAGL.h>
	#import <OpenGLES/ES1/gl.h>
	#import <OpenGLES/ES1/glext.h>
    #import <GLKit/GLKit.h>
#elif TARGET_OS_MAC
    #import <Foundation/Foundation.h>
	#import <OpenGL/gl.h>
	#import <OpenGL/glu.h>
	#import <OpenGL/CGLTypes.h>
#endif

#import "JFGC.h"


/*
 * This class loads images intended for use as OpenGL textures.
 */
@interface JFOpenGLTextureImage : NSObject {
	
	// This image's OpenGL texture ID.
	GLuint _textureId;
	
	CGFloat _alphaValue;
    
#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR
    // Texture info for GLKit, if used.
    GLKTextureInfo *_textureInfo;
#endif
}


#pragma mark - Properties

@property (nonatomic, assign) CGFloat alphaValue;

#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR
@property (nonatomic, readonly) GLKTextureInfo *textureInfo;
#endif


+ (id) textureImage;

- (GLuint) textureId;

#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR
	- (void) loadFromData: (NSData *) data;
	- (void) loadFromImage: (UIImage *) image;
    - (void) loadForGLKitFromData: (NSData *) data;
    - (void) loadForGLKitFromData: (NSData *) data originIsBottomLeft: (BOOL) originIsBottomLeft;
#elif TARGET_OS_MAC
	- (void) loadFromData: (NSData *) data toSize: (NSSize) size;
	- (void) loadFromImage: (NSImage *)image toSize: (NSSize) size;
#endif



@end
