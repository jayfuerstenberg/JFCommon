//
//  JFOpenGLTriangle.m
//  JFCommon
//
//  Created by Jason Fuerstenberg on 2013/10/2.
//
//

#import "JFOpenGLTriangle.h"

@implementation JFOpenGLTriangle


#pragma mark - Properties

@synthesize a = _a;
@synthesize b = _b;
@synthesize c = _c;


#pragma mark - Object lifecycle methods

+ (id) triangle {
	
	id tri = [[JFOpenGLTriangle alloc] init];
	[tri autorelease];
	
	return tri;
}

+ (id) triangleWithInitializedPoints {
	
	id tri = [[JFOpenGLTriangle alloc] init];
	[tri autorelease];
	
	[tri setA: [JFOpenGLPoint point]];
	[tri setB: [JFOpenGLPoint point]];
	[tri setC: [JFOpenGLPoint point]];
	
	return tri;
}

- (void) dealloc {
	
	[_a release];
	[_b release];
	[_c release];
	
	[super dealloc];
}

// TODO: implement rendering methods for various OpenGL APIs.

@end
