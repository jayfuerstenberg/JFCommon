//
// JFOpenGLTextureImage.h
// JFCommon
//
// Created by Jason Fuerstenberg on 09/11/03.
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
#import <Foundation/Foundation.h>
#import <OpenGL/gl.h>
#import <OpenGL/glu.h>
#import <OpenGL/CGLTypes.h>

#import "JFGC.h"
#import "JFMemoryManager.h"


/*
 * This class loads images intended for use as OpenGL textures.
 */
@interface JFOpenGLTextureImage : NSObject {
	
	// This image's OpenGL texture ID.
	GLuint _textureId;
	
	CGFloat _alphaValue;
}

@property (nonatomic, assign) CGFloat alphaValue;

- (GLuint) textureId;
- (void) loadFromData: (NSData *) data toSize: (NSSize) size;
- (void) loadFromImage: (NSImage *)image toSize: (NSSize) size;

@end
