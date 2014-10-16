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


#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR


#pragma mark - iOS implementation

@implementation JFOpenGLView


#pragma mark - Properties

@synthesize positionSlot = _positionSlot;
@synthesize colorSlot = _colorSlot;
@synthesize baseEffect = _baseEffect;


#pragma mark - Object lifecycle methods

- (id) init {
    
    NSLog(@"Invoke initWithFrame: instead.");
    [self release];
    return nil;
}

- (id) initWithFrame: (CGRect) frame openGlApiVersion: (NSUInteger) openGlApiVersion originIsBottomLeft: (BOOL) originIsBottomLeft {
    
    if ((self = [super initWithFrame: frame])) {
        
        _openGlApiVersion = openGlApiVersion;
        _originIsBottomLeft = originIsBottomLeft;

        switch (openGlApiVersion) {
            case 1:
                _context = [[EAGLContext alloc] initWithAPI: kEAGLRenderingAPIOpenGLES1];
                break;
            case 2:
                _context = [[EAGLContext alloc] initWithAPI: kEAGLRenderingAPIOpenGLES2];
                break;
            default:
                // NOTE: OpenGL 3.0 is not supported at this time.
                [self release];
                return nil;
        }
        
        [self setContext: _context];
        [EAGLContext setCurrentContext: _context];
        
        [self setDrawableColorFormat: GLKViewDrawableColorFormatRGBA8888];
        [self setDrawableDepthFormat: GLKViewDrawableDepthFormat16];
        
        BOOL isIPodTouch = [[UIDevice currentDevice].model isEqualToString: @"iPod touch"];
        BOOL isIPhone4 = [[UIDevice currentDevice].model isEqualToString: @"iPhone3,1"];
        if (!isIPodTouch && !isIPhone4) {
            [self setDrawableMultisample: GLKViewDrawableMultisample4X];
        }
        
        if (openGlApiVersion == 2) {
            [self lazyInitBaseEffect];
        }
    }
	
    return self;
}

- (void) dealloc {
	
#if !__has_feature(objc_arc)
    
    if ([EAGLContext currentContext] == _context) {
        [EAGLContext setCurrentContext: nil];
    }
    
    [_context release];
    [_baseEffect release];
    
	[super dealloc];

#else
    if ([EAGLContext currentContext] == _context) {
        [EAGLContext setCurrentContext: nil];
    }
    
    _context = nil;
    _baseEffect = nil;
#endif
}


#pragma mark - Lazy-initialization methods

- (void) lazyInitBaseEffect {
    
    if (_baseEffect != nil) {
        return;
    }
    
    _baseEffect = [[GLKBaseEffect alloc] init];
    
    if (_originIsBottomLeft) {
        GLKMatrix4 projectionMatrix = GLKMatrix4MakeOrtho(0, self.bounds.size.width, 0, self.bounds.size.height, -1024, 1024);
        _baseEffect.transform.projectionMatrix = projectionMatrix;
    } else {
        GLKMatrix4 projectionMatrix = GLKMatrix4MakeOrtho(0, self.bounds.size.width, self.bounds.size.height, 0, -1024, 1024);
        _baseEffect.transform.projectionMatrix = projectionMatrix;
    }
}


#pragma mark - Drawing methods

- (void) resetBaseEffect {
    
    CGRect bounds = self.bounds;
    
    if (_originIsBottomLeft) {
        GLKMatrix4 projectionMatrix = GLKMatrix4MakeOrtho(0, bounds.size.width, 0, bounds.size.height, -1024, 1024);
        _baseEffect.transform.projectionMatrix = projectionMatrix;
    } else {
        GLKMatrix4 projectionMatrix = GLKMatrix4MakeOrtho(0, bounds.size.width, bounds.size.height, 0, -1024, 1024);
        _baseEffect.transform.projectionMatrix = projectionMatrix;
    }
}

- (void) render {
    
    glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    if (_openGlApiVersion == 1) {
        // Clear any previous texture.
        glBindTexture(GL_TEXTURE_2D, 0);
        glEnable(GL_TEXTURE_2D);
    }
    
	glEnable(GL_BLEND);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
}

- (void) drawRect: (CGRect) rect {
    
    [self render];
}

@end

#elif TARGET_OS_MAC


#pragma mark - OSX implementation

@implementation JFOpenGLView


#pragma mark - Object lifecycle methods

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
	
	return self;
}


#pragma mark - View lifecycle methods

/*
 * Prepares the OpenGL configuration.
 */
- (void) prepareOpenGL {
    
    if (_setup) {
        return;
    }
    
    _setup = YES;
	
    @synchronized (self) {
        
        NSRect optimalRect = [JFOpenGLUtil optimalRectForParentRect: [self frame]
                                                    withAspectRatio: 16.0f / 9.0f];
        
        glViewport(0, 0, (GLint) optimalRect.size.width, (GLint) optimalRect.size.height);
        
        float pointSizeGranularity = 0.0f;
        glGetFloatv(GL_POINT_SIZE_GRANULARITY, &pointSizeGranularity);
        NSLog(@"OpenGL - Point size granularity = %f", pointSizeGranularity);
        
        glMatrixMode(GL_PROJECTION);
        glLoadIdentity();
        glOrtho(0.0f, /*optimalRect.size.width*/1422.0f, /*optimalRect.size.height*/800.0f, 0, 1.0f, 10000.0f); // TODO: need to look into these.
        
        // GLKMatrix4MakeOrtho(0, self.bounds.size.width, self.bounds.size.height, 0, -1024, 1024);
        
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
        
        glClearDepth(1.0f);                         // Depth Buffer Setup
        glEnable(GL_DEPTH_TEST);                    // Enables Depth Testing
        glDepthFunc(GL_LEQUAL);
        
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
        glTranslatef(0.0, 0.0, -10000.0);
        
        GLint myMaxTextureSize;
        glGetIntegerv(GL_MAX_TEXTURE_SIZE, &myMaxTextureSize);
        NSLog(@"OpenGL - Maximum texture size = %i", myMaxTextureSize);
        
        // Prevent tearing by syncing up display to VBL...
        GLint newSwapInterval = 1;
        [[self openGLContext] setValues: &newSwapInterval
                           forParameter: NSOpenGLCPSwapInterval];
    }
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


#pragma mark - Drawing methods

- (void) render {
	// NOTE: Override this method in child class to perform actual rendering.
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
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    glEnable(GL_TEXTURE_2D);
    glBindTexture(GL_TEXTURE_2D, 0);
    glDisable(GL_TEXTURE_2D);
    
	glEnable(GL_BLEND);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
	
	// Rely on the render method to perform the actual rendering.
	[self render];
	
    // Push all changes out to the display...
	[[self openGLContext] flushBuffer];
}

@end

#endif