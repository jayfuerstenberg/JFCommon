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

@implementation JFOpenGLUtil

/*
 * Draws a pseudo-line using a quad.
 * This method should be used when wide lines are required and the OpenGL implementation
 * does not support such widths.
 *
 * NOTE: This method may be processor intensive and if thin line widths can be used the
 *		 standard OpenGL line drawing method is advised.
 */
+ (void) drawQuadLineWithWidth: (CGFloat) width red: (CGFloat) red green: (CGFloat) green blue: (CGFloat) blue from: (CGPoint) beginPoint to: (CGPoint) endPoint {
	
	CGPoint cornerPoint = [JFOpenGLUtil quadCornerOffsetFrom: beginPoint
											   whenDrawingTo: endPoint
											   withLineWidth: width];
	
	glBegin(GL_QUADS);
	glColor3f(red, green, blue);
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
