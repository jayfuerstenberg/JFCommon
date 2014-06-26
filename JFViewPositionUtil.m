//
// JFViewPositionUtil.m
// JFCommon
//
// Created by Jason Fuerstenberg on 11/07/04.
// Copyright 2011 Jason Fuerstenberg
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


#import "JFViewPositionUtil.h"


@implementation JFViewPositionUtil

#pragma mark - Superview centric alignment methods

/*
 * Vertically centers the provided view at x within the superview.
 *
 * Params
 *		view				The view to vertically center
 *		superview			The super view within which the view will be vertically centered.
 *		x					The horizontal offset from which the view will be vertically centered.
 */
+ (void) verticallyCenterView: (VIEW_TYPE *) view withinSuperview: (VIEW_TYPE *) superview atX: (CGFloat) x {
	
	CGFloat superViewCenter = superview.bounds.size.height / 2.0f;
	CGFloat viewCenter = view.bounds.size.height / 2.0f;
	CGFloat y = superViewCenter - viewCenter;
	
	RECT_TYPE frame = [view frame];
	#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR
		RECT_TYPE newFrame = CGRectMake(x,
										y,
										frame.size.width,
										frame.size.height);
		[view setFrame: newFrame];
	#else
		RECT_TYPE newFrame = NSMakeRect(x,
										y,
										frame.size.width,
										frame.size.height);
		[view setFrame: newFrame];
	#endif
}

/*
 * Centers the provided view at y within the superview.
 *
 * Params
 *		view				The view to center
 *		superview			The super view within which the view will be centered.
 *		y					The vertical offset from which the view will be centered.
 */
+ (void) centerView: (VIEW_TYPE *) view withinSuperView: (VIEW_TYPE *) superView atY: (CGFloat) y {
	
	CGFloat superViewCenter = superView.bounds.size.width / 2.0f;
	CGFloat viewCenter = view.bounds.size.width / 2.0f;
	CGFloat x = superViewCenter - viewCenter;
	
	RECT_TYPE frame = [view frame];
	#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR
		RECT_TYPE newFrame = CGRectMake(x,
										y,
										frame.size.width,
										frame.size.height);
		[view setFrame: newFrame];
	#else
		RECT_TYPE newFrame = NSMakeRect(x,
										y,
										frame.size.width,
										frame.size.height);
		[view setFrame: newFrame];
	#endif
}

/*
 * Centers the provided view within the superview.
 *
 * Params
 *		view				The view to center
 *		superview			The super view within which the view will be centered.
 */
+ (void) centerView: (VIEW_TYPE *) view withinSuperView: (VIEW_TYPE *) superView {
	
	CGFloat superViewCenterX = superView.bounds.size.width / 2.0f;
	CGFloat viewCenterX = view.bounds.size.width / 2.0f;
	CGFloat x = superViewCenterX - viewCenterX;
	CGFloat superViewCenterY = superView.bounds.size.height / 2.0f;
	CGFloat viewCenterY = view.bounds.size.height / 2.0f;
	CGFloat y = superViewCenterY - viewCenterY;
	
	RECT_TYPE frame = [view frame];
	#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR
		RECT_TYPE newFrame = CGRectMake(x,
										y,
										frame.size.width,
										frame.size.height);
		[view setFrame: newFrame];
	#else
		RECT_TYPE newFrame = NSMakeRect(x,
										y,
										frame.size.width,
										frame.size.height);
		[view setFrame: newFrame];
	#endif
}

/*
 * Centers the provided view within the super view and below a sibling distanced by the margin/offset.
 *
 * Params
 *		view				The view to center.
 *		superview			The super view within which the view will be centered.
 *		siblingView			The sibling view under which the view will appear.
 *		margin				The margin/offset between the view and the sibling view.
 */
+ (void) centerView: (VIEW_TYPE *) view withinSuperView: (VIEW_TYPE *) superView belowSiblingView: (VIEW_TYPE *) siblingView withMargin: (CGFloat) margin {
	
	CGFloat superViewCenter = superView.bounds.size.width / 2.0f;
	CGFloat siblingCenter = siblingView.frame.origin.x + (siblingView.frame.size.width / 2.0f);
	
	CGPoint marginPoint = CGPointMake(superViewCenter - siblingCenter, margin);
	[JFViewPositionUtil snapAnchorPoint: JFAnchorPointTop
								 ofView: view
							 withMargin: marginPoint
						fromAnchorPoint: JFAnchorPointBottom
						  ofSiblingView: siblingView];
}


#pragma mark - Sibling view centric alignment methods

/*
 * Aligns the provided view below a sibling view distanced by the margin/offset and positions it at x.
 *
 * Params
 *		view				The view to left align.
 *      x                   The new x coordinate of the view.
 *		siblingView			The sibling view under which the view will appear.
 *		margin				The margin/offset between the view and the sibling view.
 */
+ (void) alignView: (VIEW_TYPE *) view atX: (CGFloat) x belowSiblingView: (VIEW_TYPE *) siblingView withMargin: (CGFloat) margin {
    
    RECT_TYPE siblingFrame = [siblingView frame];
    CGFloat y = siblingFrame.origin.y + siblingFrame.size.height + margin;
    RECT_TYPE frame = [view frame];
#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR
    RECT_TYPE newFrame = CGRectMake(x, y, frame.size.width, frame.size.height);
    [view setFrame: newFrame];
#else
    RECT_TYPE newFrame = NSMakeRect(x, y, frame.size.width, frame.size.height);
    [view setFrame: newFrame];
#endif
}

/*
 * Left aligns the provided view below a sibling view distanced by the margin/offset.
 *
 * Params
 *		view				The view to left align.
 *		siblingView			The sibling view under which the view will appear.
 *		margin				The margin/offset between the view and the sibling view.
 */
+ (void) leftAlignView: (VIEW_TYPE *) view belowSiblingView: (VIEW_TYPE *) siblingView withMargin: (CGFloat) margin {
	
	CGPoint marginPoint = CGPointMake(0.0f, margin);
	[JFViewPositionUtil snapAnchorPoint: JFAnchorPointTopLeft
								 ofView: view
							 withMargin: marginPoint
						fromAnchorPoint: JFAnchorPointBottomLeft
						  ofSiblingView: siblingView];
}

/*
 * Right aligns the provided view below a sibling view distanced by the margin/offset.
 *
 * Params
 *		view				The view to right align.
 *		siblingView			The sibling view under which the view will appear.
 *		margin				The margin/offset between the view and the sibling view.
 */
+ (void) rightAlignView: (VIEW_TYPE *) view belowSiblingView: (VIEW_TYPE *) siblingView withMargin: (CGFloat) margin {
	
	CGPoint marginPoint = CGPointMake(0.0f, margin);
	[JFViewPositionUtil snapAnchorPoint: JFAnchorPointTopRight
								 ofView: view
							 withMargin: marginPoint
						fromAnchorPoint: JFAnchorPointBottomRight
						  ofSiblingView: siblingView];
}

/*
 * Centers the provided view below a sibling view distanced by the margin/offset.
 *
 * Params
 *		view				The view to center.
 *		siblingView			The sibling view under which the view will appear.
 *		margin				The margin/offset between the view and the sibling view.
 */
+ (void) centerView: (VIEW_TYPE *) view belowSiblingView: (VIEW_TYPE *) siblingView withMargin: (CGFloat) margin {
	
	CGPoint marginPoint = CGPointMake(0.0f, margin);
	[JFViewPositionUtil snapAnchorPoint: JFAnchorPointTop
								 ofView: view
							 withMargin: marginPoint
						fromAnchorPoint: JFAnchorPointBottom
						  ofSiblingView: siblingView];
}

/*
 * Vertically centers the provided view to the left of a sibling view distanced by the margin/offset.
 *
 * Params
 *		view				The view to vertically center.
 *		siblingView			The sibling view to the left of which the view will appear.
 *		margin				The margin/offset between the view and the sibling view.
 */
+ (void) verticallyCenterView: (VIEW_TYPE *) view leftOfSiblingView: (VIEW_TYPE *) siblingView withMargin: (CGFloat) margin {
	
	CGPoint marginPoint = CGPointMake(-margin, 0.0f);
	[JFViewPositionUtil snapAnchorPoint: JFAnchorPointRight
								 ofView: view
							 withMargin: marginPoint
						fromAnchorPoint: JFAnchorPointLeft
						  ofSiblingView: siblingView];
}

/*
 * Vertically centers the provided view to the right of a sibling view distanced by the margin/offset.
 *
 * Params
 *		view				The view to vertically center.
 *		siblingView			The sibling view to the right of which the view will appear.
 *		margin				The margin/offset between the view and the sibling view.
 */
+ (void) verticallyCenterView: (VIEW_TYPE *) view rightOfSiblingView: (VIEW_TYPE *) siblingView withMargin: (CGFloat) margin {
	
	CGPoint marginPoint = CGPointMake(margin, 0.0f);
	[JFViewPositionUtil snapAnchorPoint: JFAnchorPointLeft
								 ofView: view
							 withMargin: marginPoint
						fromAnchorPoint: JFAnchorPointRight
						  ofSiblingView: siblingView];
}


#pragma mark - Lower level snapping methods

/*
 * Snaps the provided view by the anchor point to the sibling view's anchor point.
 * If either view is nil the method will perform no anchoring.
 *
 * Params
 *		anchorPoint			The view's anchor point.
 *		view				The view to anchor.
 *		siblingAnchorPoint	The sibling view's anchor point.
 *		siblingView			The sibling view.
 */
+ (void) snapAnchorPoint: (JFAnchorPoint) anchorPoint ofView: (VIEW_TYPE *) view toAnchorPoint: (JFAnchorPoint) siblingAnchorPoint ofSiblingView: (VIEW_TYPE *) siblingView {
	
	if (view == nil || siblingView == nil) {
		// At least one of the views is not usable.
		return;
	}
	
	CGPoint siblingPoint = [JFViewPositionUtil pointForAnchorPoint: siblingAnchorPoint
															ofView: siblingView];
	CGPoint point = [JFViewPositionUtil pointForAnchorPoint: anchorPoint
													 ofView: view];
	
	[JFViewPositionUtil moveView: view
				 bySnappingPoint: point
					toOtherPoint: siblingPoint];
}


/*
 * Snaps the provided view by the anchor point to the sibling view's anchor point.
 * If either view is nil the method will perform no anchoring.
 *
 * Params
 *		anchorPoint			The view's anchor point.
 *		view				The view to anchor.
 *		margin				The margin/offset from the sibling anchor point.
 *		siblingAnchorPoint	The sibling view's anchor point.
 *		siblingView			The sibling view.
 */
+ (void) snapAnchorPoint: (JFAnchorPoint) anchorPoint ofView: (VIEW_TYPE *) view withMargin: (CGPoint) margin fromAnchorPoint: (JFAnchorPoint) siblingAnchorPoint ofSiblingView: (VIEW_TYPE *) siblingView {
	
	if (view == nil || siblingView == nil) {
		// At least one of the views is not usable.
		return;
	}
	
	CGPoint siblingPoint = [JFViewPositionUtil pointForAnchorPoint: siblingAnchorPoint
															ofView: siblingView];
	CGPoint point = [JFViewPositionUtil pointForAnchorPoint: anchorPoint
													 ofView: view];
	
	[JFViewPositionUtil moveView: view
				 bySnappingPoint: point
					toOtherPoint: siblingPoint
					  withMargin: margin];
}

/*
 * Moves the provided view by snapping its point to another point.
 *
 * Params
 *		view				The view to move.
 *		point				The point being snapped.
 *		otherPoint			The point against which the first point will be snapped.
 */
+ (void) moveView: (VIEW_TYPE *) view bySnappingPoint: (CGPoint) point toOtherPoint: (CGPoint) otherPoint {
	
	CGFloat xDiff = otherPoint.x - point.x;
	CGFloat yDiff = otherPoint.y - point.y;
	
	RECT_TYPE frame = [view frame];
	#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR
		RECT_TYPE newFrame = CGRectMake(frame.origin.x += xDiff,
										frame.origin.y += yDiff,
										frame.size.width,
										frame.size.height);
		[view setFrame: newFrame];
	#else
		RECT_TYPE newFrame = NSMakeRect(frame.origin.x += xDiff,
										frame.origin.y += yDiff,
										frame.size.width,
										frame.size.height);
		[view setFrame: newFrame];
	#endif
}

/*
 * Moves the provided view by snapping its point to another while also considering the margin/offset.
 *
 * Params
 *		view				The view to move.
 *		point				The point being snapped.
 *		otherPoint			The point against which the first point will be snapped.
 *		margin				The margin/offset from the other point to consider when snapping the point of the view.
 */
+ (void) moveView: (VIEW_TYPE *) view bySnappingPoint: (CGPoint) point toOtherPoint: (CGPoint) otherPoint withMargin: (CGPoint) margin {
	
	CGFloat xDiff = otherPoint.x - point.x;
	CGFloat yDiff = otherPoint.y - point.y;
	
	RECT_TYPE frame = [view frame];
	#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR
		RECT_TYPE newFrame = CGRectMake((frame.origin.x += xDiff) + margin.x,
										(frame.origin.y += yDiff) + margin.y,
										frame.size.width,
										frame.size.height);
		[view setFrame: newFrame];
	#else
		RECT_TYPE newFrame = NSMakeRect((frame.origin.x += xDiff) + margin.x,
										(frame.origin.y += yDiff) + margin.y,
										frame.size.width,
										frame.size.height);
		[view setFrame: newFrame];
	#endif
}


#pragma mark - Point retrieval method

/*
 * Returns the point within the view designated by the provided anchor point.
 * The provided view must not be nil.
 *
 * Params
 *		anchorPoint			The view's anchor point.
 *		view				The view whose point is being returned.
 *
 * Return
 *		A CGPoint struct.
 */
+ (CGPoint) pointForAnchorPoint: (JFAnchorPoint) anchorPoint ofView: (VIEW_TYPE *) view {
	
	RECT_TYPE frame = [view frame];
	CGFloat x = 0.0f;
	CGFloat y = 0.0f;
	
	switch (anchorPoint) {
		case JFAnchorPointTopLeft:
			x = frame.origin.x;
			y = frame.origin.y;
			break;
			
		case JFAnchorPointTop:
			x = (frame.size.width / 2.0f) + frame.origin.x;
			y = frame.origin.y;
			break;
			
		case JFAnchorPointTopRight:
			x = frame.size.width + frame.origin.x;
			y = frame.origin.y;
			break;
			
		case JFAnchorPointLeft:
			x = frame.origin.x;
			y = (frame.size.height / 2.0f) + frame.origin.y;
			break;
			
		case JFAnchorPointCenter:
			x = (frame.size.width / 2.0f) + frame.origin.x;
			y = (frame.size.height / 2.0f) + frame.origin.y;
			break;
			
		case JFAnchorPointRight:
			x = frame.size.width + frame.origin.x;
			y = (frame.size.height / 2.0f) + frame.origin.y;
			break;
			
		case JFAnchorPointBottomLeft:
			x = frame.origin.x;
			y = frame.size.height + frame.origin.y;
			break;
			
		case JFAnchorPointBottom:
			x = (frame.size.width / 2.0f) + frame.origin.x;
			y = frame.size.height + frame.origin.y;
			break;
			
		case JFAnchorPointBottomRight:
			x = frame.size.width + frame.origin.x;
			y = frame.size.height + frame.origin.y;
			break;
	}
	
	return CGPointMake(x, y);
}


#pragma mark - Extra methods

/*
 * Sets the height of the provided view to fit all its subviews and adding the margin.
 *
 * Params
 *		superview			The view to resize.
 *		margin				The margin to add to the eventual height.
 */
+ (void) setHeightOfSuperview: (VIEW_TYPE *) superview toFitAllSubviewsWithMargin: (CGFloat) margin {
	
	CGFloat deepestY = 0.0f;
	
	NSArray *subviews = [superview subviews];
	
	for (VIEW_TYPE *subview in subviews) {
		CGFloat y = subview.frame.origin.y + subview.frame.size.height;
		
		if (y > deepestY) {
			deepestY = y;
		}
	}
	
	RECT_TYPE currentFrame = superview.frame;
	#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR
		RECT_TYPE newFrame = CGRectMake(currentFrame.origin.x, currentFrame.origin.y, currentFrame.size.width, deepestY + margin);
		[superview setFrame: newFrame];
	#else
		RECT_TYPE newFrame = NSMakeRect(currentFrame.origin.x, currentFrame.origin.y, currentFrame.size.width, deepestY + margin);
		[superview setFrame: newFrame];
	#endif
	
	#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR
		if ([superview isKindOfClass: [UIScrollView class]]) {
			// The superview being resized is a scroll view so also set its content size to match its actual size.
			UIScrollView *scrollView = (UIScrollView *) superview;
			[scrollView setContentSize: newFrame.size];
		}
	#endif
}

/*
 * Snaps the provided view to neatly discreet coordinates.
 *
 * Params
 *		view				The view whose coordinates will be snapped.
 */
+ (void) snapViewToDiscreteCoordinates: (VIEW_TYPE *) view {
	
	if (view == nil) {
		return;
	}
	
	CGPoint point = [JFViewPositionUtil pointForAnchorPoint: JFAnchorPointTopLeft
													 ofView: view];
	point.x = round(point.x);
	point.y = round(point.y);
	
	#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR
		[view setFrame: CGRectMake(point.x, point.y, view.frame.size.width, view.frame.size.height)];
	#else
		[view setFrame: NSMakeRect(point.x, point.y, view.frame.size.width, view.frame.size.height)];
	#endif
}

@end
