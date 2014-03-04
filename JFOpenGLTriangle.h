//
//  JFOpenGLTriangle.h
//  JFCommon
//
//  Created by Jason Fuerstenberg on 2013/10/02.
//
//

#import <Foundation/Foundation.h>

#import "JFOpenGLPoint.h"

@interface JFOpenGLTriangle : NSObject {
	
@public
	JFOpenGLPoint *_a;
	JFOpenGLPoint *_b;
	JFOpenGLPoint *_c;
    
    // TODO: might be good to emulate the guad class style by having the transform matrix etc... here
}


@property (nonatomic, retain) JFOpenGLPoint *a;
@property (nonatomic, retain) JFOpenGLPoint *b;
@property (nonatomic, retain) JFOpenGLPoint *c;


+ (id) triangle;
+ (id) triangleWithInitializedPoints;

@end
