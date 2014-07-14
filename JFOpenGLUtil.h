//
// JFOpenGLUtil.h
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

#import <Foundation/Foundation.h>

#import "JFOpenGLCStructs.h"
#import "JFOpenGLPositionable.h"
#import "JFOpenGLMatrix.h"
#import "JFOpenGLVertex.h"
#import "JFOpenGLCamera.h"


/*
 * Convenient utility class for various OpenGL methods.
 */
@interface JFOpenGLUtil : NSObject

#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR

+ (void) drawOpenGl1TriangleFanPointWithWidth: (CGFloat) width red: (CGFloat) red green: (CGFloat) green blue: (CGFloat) blue alpha: (CGFloat) alpha atPoint: (CGPoint) point;
+ (void) drawOpenGl2TriangleFanPointWithWidth: (CGFloat) width red: (CGFloat) red green: (CGFloat) green blue: (CGFloat) blue alpha: (CGFloat) alpha atPoint: (CGPoint) point;
+ (void) drawOpenGl1QuadLineWithWidth: (CGFloat) width red: (CGFloat) red green: (CGFloat) green blue: (CGFloat) blue alpha: (CGFloat) alpha from: (CGPoint) beginPoint to: (CGPoint) endPoint;
+ (void) drawOpenGl2QuadLineWithWidth: (CGFloat) width red: (CGFloat) red green: (CGFloat) green blue: (CGFloat) blue alpha: (CGFloat) alpha from: (CGPoint) beginPoint to: (CGPoint) endPoint;

#elif TARGET_OS_MAC

+ (void) drawTriangleFanPointWithWidth: (CGFloat) width red: (CGFloat) red green: (CGFloat) green blue: (CGFloat) blue alpha: (CGFloat) alpha atPoint: (CGPoint) point;
+ (void) drawQuadLineWithWidth: (CGFloat) width red: (CGFloat) red green: (CGFloat) green blue: (CGFloat) blue alpha: (CGFloat) alpha from: (CGPoint) beginPoint to: (CGPoint) endPoint;
+ (NSRect) optimalRectForParentRect: (NSRect) parentRect withAspectRatio: (CGFloat) aspectRatio;

#endif

+ (CGPoint) quadCornerOffsetFrom: (CGPoint) beginPoint whenDrawingTo: (CGPoint) endPoint withLineWidth: (CGFloat) lineWidth;
+ (BOOL) isPoint: (CGPoint) point insideTriangleComprisedOfA: (CGPoint) a b: (CGPoint) b c: (CGPoint) c;

@end
