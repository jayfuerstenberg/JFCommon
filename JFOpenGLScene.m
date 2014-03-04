//
// JFOpenGLScene.m
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

#import "JFOpenGLScene.h"

@implementation JFOpenGLScene


#pragma mark - Properties

@synthesize objects = _objects;


#pragma mark - Object lifecycle methods

- (void) dealloc {
    
    [_objects release];
    
    [super dealloc];
}


#pragma mark - Action methods

/*
 * Manages the scene by notifying all objects to
 * advance their internal state if needed.
 */
- (void) advance {

    @synchronized (_objects) {
        for (id <JFOpenGLRenderable> renderable in _objects) {
            [renderable advance];
        }
    }
}

/*
 * Renders the scene.
 */
- (void) renderWithCamera: (JFOpenGLCamera *) camera {

    @synchronized (_objects) {
        for (id <JFOpenGLRenderable> renderable in _objects) {
            [renderable transformWithCamera: camera];
            [renderable render];
        }
    }
}

@end
