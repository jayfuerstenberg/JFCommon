//
// JFOpenGLUtil.m
// JFCommon
//
// Created by Jason Fuerstenberg on 2012/11/20.
// Copyright (c) 2012 Jason Fuerstenberg. All rights reserved.
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

#import "JFOpenGLUtil.h"

#define JFOpenGLUtilTriangleFanPointGranularity		16

CGPoint __JFOpenGLUtil__PreviousTriangleFanPoints__[JFOpenGLUtilTriangleFanPointGranularity];
CGFloat __JFOpenGLUtil__PreviousTriangleFanPointWidth__ = 0.0f;


@implementation JFOpenGLUtil


/*
 * Draws a pseudo-point using a triangle fan.
 * This method should be used when wide points are required and the OpenGL implementation does not support such widths.
 *
 * NOTE: This method assumes that a point is being drawn at both ends of a line and at every bend where such a line curves.
 *		 As such the point width is meant to match the line width which doesn't change and the calculation of the triangle
 *		 fan can be optimized to reuse the edge points.
 *
 * NOTE: This method may be processor intensive and if thin point widths can be used standard OpenGL point drawing is recommended.
 */
+ (void) drawTriangleFanPointWithWidth: (CGFloat) width red: (CGFloat) red green: (CGFloat) green blue: (CGFloat) blue alpha: (CGFloat) alpha atPoint: (CGPoint) point {
	
	if (__JFOpenGLUtil__PreviousTriangleFanPointWidth__ != width) {
		CGFloat halfWidth = width * 0.5f;
		// Have to calculate the points to suit the provided width...
		JFOpenGLVertex *vertex = [[JFOpenGLVertex alloc] initWithX: halfWidth
																 y: 0.0f
																 z: 0.0f];
		
		// The first edge point is directly to the right of the center point.
		__JFOpenGLUtil__PreviousTriangleFanPoints__[0] = CGPointMake(halfWidth, 0.0f);

		JFOpenGLMatrix *rotationMatrix = [JFOpenGLMatrix matrix];
		[rotationMatrix setZAngle: (360.0f / JFOpenGLUtilTriangleFanPointGranularity)];
		
		for (NSUInteger index = 1; index < JFOpenGLUtilTriangleFanPointGranularity; index++) {
			[rotationMatrix multiplyVertex: vertex];
			__JFOpenGLUtil__PreviousTriangleFanPoints__[index] = CGPointMake(vertex->_x, vertex->_y);
		}
		[vertex release];
		
		// Reset the width...
		__JFOpenGLUtil__PreviousTriangleFanPointWidth__ = width;
	}
	
	CGPoint edgePoint;
	glBegin(GL_TRIANGLE_FAN);
	glColor4f(red, green, blue, alpha);
	glVertex2f(point.x, -point.y); // center point
	for (NSUInteger index = 0; index < JFOpenGLUtilTriangleFanPointGranularity; index++) {
		edgePoint = __JFOpenGLUtil__PreviousTriangleFanPoints__[index];
		glVertex2f(point.x + edgePoint.x, -(point.y + edgePoint.y));
	}
	edgePoint = __JFOpenGLUtil__PreviousTriangleFanPoints__[0]; // Close the point.
	glVertex2f(point.x + edgePoint.x, -(point.y + edgePoint.y));
	glEnd();
}

/*
 * Draws a pseudo-line using a quad.
 * This method should be used when wide lines are required and the OpenGL implementation does not support such widths.
 *
 * NOTE: This method may be processor intensive and if thin line widths can be used the
 *		 standard OpenGL line drawing method is advised.
 */
+ (void) drawQuadLineWithWidth: (CGFloat) width red: (CGFloat) red green: (CGFloat) green blue: (CGFloat) blue alpha: (CGFloat) alpha from: (CGPoint) beginPoint to: (CGPoint) endPoint {
	
	CGPoint cornerPoint = [JFOpenGLUtil quadCornerOffsetFrom: beginPoint
											   whenDrawingTo: endPoint
											   withLineWidth: width];
	
	glBegin(GL_QUADS);
	glColor4f(red, green, blue, alpha);
	glVertex2f(beginPoint.x - cornerPoint.x, -(beginPoint.y - cornerPoint.y));
	glVertex2f(beginPoint.x + cornerPoint.x, -(beginPoint.y + cornerPoint.y));
	glVertex2f(endPoint.x + cornerPoint.x, -(endPoint.y + cornerPoint.y));
	glVertex2f(endPoint.x - cornerPoint.x, -(endPoint.y - cornerPoint.y));
	glEnd();
}


/*
 * Calculates and returns the corner offset from the provided beginning point.
 * This offset can be reused to form the other 3 points needed to draw a quad.
 */
+ (CGPoint) quadCornerOffsetFrom: (CGPoint) beginPoint whenDrawingTo: (CGPoint) endPoint withLineWidth: (CGFloat) lineWidth {
	
	// Some sanity checking...
	if (lineWidth < 1.0f) {
		// Reject this call.
		return CGPointZero;
	}
	
	if ([JFOpenGLUtil isBeginPoint: beginPoint
				   equalToEndPoint: endPoint]) {
		// Better off rendering this as a point instead.
		return CGPointZero;
	}
	
	CGFloat xDifference = endPoint.x - beginPoint.x;
	CGFloat yDifference = endPoint.y - beginPoint.y;
	CGFloat halfWidth = lineWidth / 2.0f;
	
	double thetaInRadians = atan2(yDifference, xDifference);
	double theta = thetaInRadians * 180.0 / M_PI;
	double perpendicular = [JFOpenGLUtil normalizeAngle: theta + 90.0];
	double perpendicularInRadians = perpendicular * M_PI / 180.0;
	
	// Get the point in the perpendicular angle at a distance of 1/2 of the line width from the beginPoint.
	double yOffset = sin(perpendicularInRadians) * halfWidth;
	double xOffset = cos(perpendicularInRadians) * halfWidth;
	
	return CGPointMake(xOffset, yOffset);
}


/*
 * Returns YES if the provided point lies within the 2D triangle made up of points A, B, and C.
 *
 * Implementation based on: http://stackoverflow.com/a/13301035/869287 but optimized for slightly better performance.
 */
+ (BOOL) isPoint: (CGPoint) point insideTriangleComprisedOfA: (CGPoint) a b: (CGPoint) b c: (CGPoint) c {
	
	// Pre-calculate reused numbers...
	CGFloat axcx = a.x - c.x;
	CGFloat bycy = b.y - c.y;
	CGFloat cxbx = c.x - b.x;
	CGFloat pxcx = point.x - c.x;
	CGFloat pycy = point.y - c.y;
	CGFloat bycyaxcxcxbxaycy = bycy * axcx + cxbx * (a.y - c.y);
	
	if (bycyaxcxcxbxaycy == 0.0f) {
		// Assume NO, in attempt to prevent DIV/0 below.
		return NO;
	}
	
	// Perform the main calculation...
	CGFloat alpha = (bycy * pxcx + cxbx * pycy) / bycyaxcxcxbxaycy;
	if (alpha <= 0.0f) {
		// Alpha is not greater than 0 so the point is already known to be outside.
		return NO;
	}
	
	CGFloat beta = ((c.y - a.y) * pxcx + axcx * pycy) / bycyaxcxcxbxaycy;
	if (beta <= 0.0f) {
		// Beta is not greater than 0 so the point is already known to be outside.
		return NO;
	}
	
	// Finally test the gamma and return the result...
	CGFloat gamma = 1.0f - alpha - beta;
	return gamma > 0.0f;
}


+ (double) normalizeAngle: (double) angle {
	
	if (angle > 360.0) {
		// Normalize this to under 360
		return angle - 360.0;
	} else if (angle < 0.0) {
		// Normalize this over 0
		return angle + 360.0;
	}
	
	return angle;
}

+ (BOOL) isBeginPoint: (CGPoint) beginPoint equalToEndPoint: (CGPoint) endPoint {
	
	if (beginPoint.x != endPoint.x) {
		return NO;
	}
	
	if (beginPoint.y != endPoint.y) {
		return NO;
	}
	
	return YES;
}

@end
