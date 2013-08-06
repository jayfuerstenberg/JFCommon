//
// JFOpenGLRenderable.h
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

#import <Foundation/Foundation.h>


@class JFOpenGLCamera;

/*
 * The protocol to which all renderable OpenGL models must adhere.
 */
@protocol JFOpenGLRenderable

/*
 * Transforms the original points to those relative to the provided camera for later rendering.
 */
- (void) transformWithCamera: (JFOpenGLCamera *) camera;

@end
