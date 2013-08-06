//
// JFOpenGLCamera.h
// JFCommon
//
// Created by Jason Fuerstenberg on 2006/06/12.
// Copyright (c) 2006 Jason Fuerstenberg. All rights reserved.
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
#import <math.h>

#import "JFOpenGLPositionable.h"
#import "JFOpenGLVertex.h"
#import "JFOpenGLMatrix.h"


/*
 * The camera pans and zooms around a document and any annotations
 * to help render them in their proper locations in the view.
 */
@interface JFOpenGLCamera : NSObject <JFOpenGLPositionable> {

    // The center reference point.
	JFOpenGLVertex *_referencePoint;
	
	/*
	 * The reference point against which transformations will occur.
	 * This may point to this class' referencePoint member or any other reference point.
	 */
	JFOpenGLVertex *_transformReferencePoint; // TODO: is this used?
	
	// The matrix which will assist in rendering calculations.
	JFOpenGLMatrix *_transformMatrix;
	
	// Flag indicating whether matrix should be updated in accordance with a change to this model.
	BOOL _shouldUpdateTransformMatrix;
    
    GLfloat _width;
	
	GLfloat _height;
	
	GLfloat _halfWidth;
	
	GLfloat _halfHeight;
	
	// The left edge's x coordinate for comparison purposes.
	GLfloat _leftOnScreenX;
	
	// The right edge's x coordinate for comparison purposes.
	GLfloat _rightOnScreenX;
	
	// The bottom edge's y coordinate for comparison purposes.
	GLfloat _bottomOnScreenY;
	
	// The top edge's y coordinate for comparison purposes.
	GLfloat _topOnScreenY;
}


#pragma mark - Properties

#if !__has_feature(objc_arc)
	@property (nonatomic, retain) JFOpenGLVertex *referencePoint;
	@property (nonatomic, retain) JFOpenGLVertex *transformReferencePoint;
	@property (nonatomic, retain) JFOpenGLMatrix *transformMatrix;
#else
	@property (nonatomic, strong) JFOpenGLVertex *referencePoint;
	@property (nonatomic, strong) JFOpenGLVertex *transformReferencePoint;
	@property (nonatomic, strong) JFOpenGLMatrix *transformMatrix;
#endif
@property (nonatomic, assign) BOOL shouldUpdateTransformMatrix;


#pragma mark - Object lifecycle methods

- (id) initWithWidth: (GLfloat) width height: (GLfloat) height;


#pragma mark - Action methods

- (void) updateOnScreenCoordinates;
- (void) transformVertex: (JFOpenGLVertex *) vertex;

- (void) panLeft: (GLfloat) left;
- (void) panRight: (GLfloat) right;


@end
