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
#elif TARGET_OS_MAC
    #import <Foundation/Foundation.h>
#endif


#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR


#pragma mark - iOS implementation

/*
 * NOTE: This class is built upon the GLKit stnadard to abstract away
 * The buffer maintenance logic and for easy enabling of anti-aliasing.
 * As such iOS 5.0 is a minimum requirement for using this class.
 */
@interface JFOpenGLView : GLKView {
	
	EAGLContext *_context;
	
	BOOL _setup;
    
    id <NSObject> _touchDelegate;
}


#pragma mark - Properties

@property (nonatomic, retain) id <NSObject> touchDelegate;


#pragma mark - Object lifecycle methods

- (id) initWithFrame: (CGRect) frameRect;

@end

#elif TARGET_OS_MAC


#pragma mark - OSX implementation

@interface JFOpenGLView : NSOpenGLView {
	
	BOOL _setup;
}


#pragma mark - Object lifecycle methods

- (id) initWithFrame: (NSRect) frameRect;

@end

#endif



