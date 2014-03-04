//
// JFOpenGLCStructs.h
// JFCommon
//
// Created by Jason Fuerstenberg on 2014/02/23.
// Copyright (c) 2014 Jason Fuerstenberg. All rights reserved.
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



typedef struct {
    
    GLfloat _x;
	GLfloat _y;
    GLfloat _z; // Used only for the depth buffer.
    
} JFOpenGLC2DPosition;


typedef struct {
    
    GLfloat _red;
    GLfloat _green;
    GLfloat _blue;
    GLfloat _alpha;
    
} JFOpenGLCRGBAColor;


typedef struct {
    
    GLfloat _u;
    GLfloat _v;
    
} JFOpenGLCTextureCoords;