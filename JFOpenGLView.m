//
// JFOpenGLView.m
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

#import "JFOpenGLView.h"

@implementation JFOpenGLView

- (id) init {
    
    NSLog(@"Invoke initWithFrame: instead.");
    [self release];
    return nil;
}

/*
 * Constructor.
 */
- (id) initWithFrame: (NSRect) frameRect {
	
	NSOpenGLPixelFormatAttribute attrs[] = {
		NSOpenGLPFAMultisample,
		NSOpenGLPFASampleBuffers, (NSOpenGLPixelFormatAttribute) 1,
		NSOpenGLPFASamples, (NSOpenGLPixelFormatAttribute) 4,
		NSOpenGLPFASampleAlpha,
		NSOpenGLPFANoRecovery,
		NSOpenGLPFAFullScreen, // Support full screen
		NSOpenGLPFAScreenMask, CGDisplayIDToOpenGLDisplayMask(kCGDirectMainDisplay), // Use the main screen
		NSOpenGLPFAColorSize, 24, // 24-bit color
		NSOpenGLPFADoubleBuffer, // Double buffer to flush buffer in one step
		NSOpenGLPFAAccelerated, // Support accelerated graphics
		0 
	};
	
	NSOpenGLPixelFormat *pixelFormat = [[NSOpenGLPixelFormat alloc] initWithAttributes: attrs];
	
	self = [super initWithFrame: frameRect
					pixelFormat: pixelFormat];
	if (self != nil) {
		_camera = [[JFOpenGLCamera alloc] initWithWidth: frameRect.size.width
												 height: frameRect.size.height];
		
		NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
		[nc addObserver: self
			   selector: @selector(reshape)
				   name: NSViewFrameDidChangeNotification
				 object: self];
	}
	
	return self;
}


- (void) dealloc {
	
#if !__has_feature(objc_arc)
	[_camera release];
	[super dealloc];
#else
	_camera = nil;
#endif
}

- (void) render {
	// NOTE: Override this method in child class to perform actual rendering.
}


/*
 * Prepares the OpenGL configuration.
 */
- (void) prepareOpenGL {
	
	NSSize size = [self frame].size;
	glViewport(0, 0, (GLint) size.width, (GLint) size.height);
	
	float pointSizeGranularity = 0.0f;
	glGetFloatv(GL_POINT_SIZE_GRANULARITY, &pointSizeGranularity);
	NSLog(@"OpenGL - Point size granularity = %f", pointSizeGranularity);
	
	glMatrixMode(GL_PROJECTION);
	glLoadIdentity();
	gluPerspective(38.0, size.width / size.height, 1.0f, 1000.0f);
	
	glMatrixMode(GL_MODELVIEW);
	glShadeModel(GL_SMOOTH);
    glEnable(GL_BLEND);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
	glEnable(GL_TEXTURE_2D);
	
    glEnable(GL_LINE_SMOOTH);
    glHint(GL_LINE_SMOOTH_HINT, GL_NICEST);
	
	glEnable(GL_POLYGON_SMOOTH);
	glHint(GL_POLYGON_SMOOTH_HINT, GL_NICEST);
	
	glEnable(GL_POINT_SMOOTH);
	glHint(GL_POINT_SMOOTH_HINT, GL_NICEST);

	glEnable(GL_MULTISAMPLE);	
	glEnable(GL_MULTISAMPLE_ARB);
    glHint(GL_MULTISAMPLE_FILTER_HINT_NV, GL_NICEST);
	
	GLfloat lineWidth = 0.0f;
	glGetFloatv(GL_LINE_WIDTH, &lineWidth);
	NSLog(@"OpenGL - Default line width = %f", lineWidth);
	
	GLfloat lineWidthGranularity = 0.0f;
	glGetFloatv(GL_LINE_WIDTH_GRANULARITY, &lineWidthGranularity);
	NSLog(@"OpenGL - Line width granularity = %f", lineWidthGranularity);
    
    GLfloat aaLineWidth[2];
    glGetFloatv(GL_ALIASED_LINE_WIDTH_RANGE, aaLineWidth);
    NSLog(@"OpenGL - Anti-aliased line width range = %f - %f", aaLineWidth[0], aaLineWidth[1]);
    
    GLfloat smoothLineWidth[2];
    glGetFloatv(GL_SMOOTH_LINE_WIDTH_RANGE, smoothLineWidth);
    NSLog(@"OpenGL - Smooth line width range = %f - %f", smoothLineWidth[0], smoothLineWidth[1]);
    
    GLfloat smoothPointSize[2];
    glGetFloatv(GL_SMOOTH_POINT_SIZE_RANGE, smoothPointSize);
    NSLog(@"OpenGL - Smooth point size range = %f - %f", smoothPointSize[0], smoothPointSize[1]);
	
	
	glLoadIdentity();
	glTranslatef(0.0, 0.0, -520.0);
	
	GLint myMaxTextureSize;
	glGetIntegerv(GL_MAX_TEXTURE_SIZE, &myMaxTextureSize);
	NSLog(@"OpenGL - Maximum texture size = %i", myMaxTextureSize);
	
	// Prevent tearing by syncing up display to VBL...
	GLint newSwapInterval = 1;
	[[self openGLContext] setValues: &newSwapInterval
					   forParameter: NSOpenGLCPSwapInterval];
	
	_setup = YES;
}


/*
 * Allows the view to accept user input.
 */
- (BOOL) acceptsFirstResponder {
	return YES;
}


/*
 * Indicates that this view is opaque (to make the view more performant at rendering time).
 */
- (BOOL) isOpaque {
	return YES;
}


/*
 * Rendering method.
 */
- (void) drawRect: (NSRect) bounds {
	
	if (!_setup) {
		return;
	}
	
	// Clear the buffer...
	glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT);
	
	// Rely on the render method to perform the actual rendering.
	[self render];
	
    // Push all changes out to the display...
	[[self openGLContext] flushBuffer];
}


@end
