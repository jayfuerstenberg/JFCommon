//
// JFOpenGLTextureImage.m
// JFCommon
//
// Created by Jason Fuerstenberg on 2009/11/03.
// Copyright 2009 Jason Fuerstenberg. All rights reserved.
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

#import "JFOpenGLTextureImage.h"


@implementation JFOpenGLTextureImage


#pragma mark - Properties

@synthesize alphaValue = _alphaValue;

#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR
@synthesize textureInfo = _textureInfo;
#endif


#pragma mark - Object lifecycle methods

+ (id) textureImage {
    
    id textureImage = [[JFOpenGLTextureImage alloc] init];
    [textureImage autorelease];
    
    return textureImage;
}

- (void) dealloc {
	
	// NOTE: The OpenGL texture has to be released from the main thread.
	[self performSelectorOnMainThread: @selector(releaseTextureInMainThread)
						   withObject: nil
						waitUntilDone: YES];
    
	[super dealloc];
}


#pragma mark - Getter / setter methods

/*
 * Returns the texture ID.
 */
- (GLuint) textureId {

	return _textureId;
}

- (void) setAlphaValue: (CGFloat) alphaValue {
	
	if (alphaValue > 1.0f) {
		alphaValue = 1.0f;
	}
	
	if (alphaValue < 0.0f) {
		alphaValue = 0.0f;
	}
	
	_alphaValue = alphaValue;
}


#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR

/*
 * Loads a texture from the given data to a particular size.
 *
 * data		The image data from which the texture will be loaded.
 */
- (void) loadFromData: (NSData *) data {
	
	if (data == nil) {
		return;
	}
    
    UIImage *image = [UIImage imageWithData: data];
    [self loadFromImage: image];
}

#elif TARGET_OS_MAC

/*
 * Loads a texture from the given data to a particular size.
 *
 * data		The image data from which the texture will be loaded.
 * size		The width and height of the resulting texture.
 */
- (void) loadFromData: (NSData *) data toSize: (NSSize) size {
	
	if (data == nil) {
		return;
	}
	
	@synchronized (self) {
		CGImageSourceRef source = CGImageSourceCreateWithData((CFDataRef) data, NULL);
		CGImageRef imageRef =  CGImageSourceCreateImageAtIndex(source, 0, NULL);
		
		if (imageRef != nil) {
			size_t imageW = CGImageGetWidth(imageRef);
			size_t imageH = CGImageGetHeight(imageRef);
			CGRect rect = [JFOpenGLTextureImage bestRectForWidth: imageW
														  height: imageH
														withSize: size];
			imageW = rect.size.width;
			imageH = rect.size.height;
			
			GLubyte *textureData = (GLubyte *) calloc(imageW * imageH << 2, 1);
			/*CGContextRef imageContext = CGBitmapContextCreate(textureData,
															  imageW,
															  imageH,
															  8,
															  imageW << 2,
															  CGImageGetColorSpace(imageRef),
															  kCGImageAlphaPremultipliedLast);*/
            
            CGContextRef imageContext = CGBitmapContextCreate(textureData,
															  imageW,
															  imageH,
															  8,
															  imageW << 2,
															  CGImageGetColorSpace(imageRef),
															  (CGBitmapInfo) kCGImageAlphaPremultipliedLast);
			
			if (imageContext != nil) {
				
				CGContextDrawImage(imageContext, // The OpenGL compatible graphics context (with a pointer to textureData, the raw memory buffer)
								   rect,
								   imageRef);	// The image loaded from memory
				glPixelStorei(GL_UNPACK_ALIGNMENT, 1);
				glPixelStorei(GL_PACK_ALIGNMENT, 1);
				glGenTextures(1, &_textureId);
				if (_textureId == 0) {
					NSLog(@"Could not generate texture ID");
				}
                
				glBindTexture(GL_TEXTURE_2D, _textureId);
                
                GLboolean isTexture = glIsTexture(_textureId);
                if (!isTexture) {
                    NSLog(@"Texture was not bound properly.");
                }
				
				// when texture area is small, bilinear filter the closest mipmap
				glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
				// when texture area is large, bilinear filter the original
				glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
                glTexParameterf(GL_TEXTURE_2D , GL_TEXTURE_WRAP_S, GL_CLAMP);
                glTexParameterf(GL_TEXTURE_2D , GL_TEXTURE_WRAP_T, GL_CLAMP);
                
				glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, size.width, size.height, 0, GL_RGBA, GL_UNSIGNED_BYTE, textureData);
				
				// NOTE: At this point OpenGL has the texture in its own buffer.
				
				GLenum err = glGetError();
				if (err != GL_NO_ERROR) {
					NSLog(@"glError: 0x%04X", err);
				}
				
				if (imageContext != nil) {
					CGContextRelease(imageContext);
				}
			}
			
			free(textureData);
		}
		
		if (imageRef != nil) {
			CFRelease(imageRef);
		}
		
		if (source != nil) {
			CFRelease(source);
		}
	}
}

#endif


#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR

/*
 * Loads a texture from the given image to a particular size.
 *
 * image	The image from which the texture will be loaded.
 */
- (void) loadFromImage: (UIImage *) image {
	
	if (image == nil) {
        return;
    }
    
    glGenTextures(1, &_textureId);
    glBindTexture(GL_TEXTURE_2D, _textureId);
    glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER,GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    
    GLuint width = CGImageGetWidth(image.CGImage);
    GLuint height = CGImageGetHeight(image.CGImage);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    void *imageData = malloc(height * width * 4);
    CGContextRef context = CGBitmapContextCreate(imageData, width, height, 8, 4 * width, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    CGContextClearRect(context, CGRectMake(0, 0, width, height));
    CGContextTranslateCTM (context, 0, height);
    CGContextScaleCTM (context, 1.0, -1.0);
    
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), image.CGImage);
    
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, imageData);
    
    // NOTE: At this point OpenGL has the texture in its own buffer.
    
    CGContextRelease(context);
    
    free(imageData);
}


#elif TARGET_OS_MAC

/*
 * Loads a texture from the given image to a particular size.
 *
 * image	The image from which the texture will be loaded.
 * size		The width and height of the resulting texture.
 */
- (void) loadFromImage: (NSImage *) image toSize: (NSSize) size {
	
    /*if (image == nil) {
        return;
    }
    
    glGenTextures(1, &_textureId);
    glBindTexture(GL_TEXTURE_2D, _textureId);
    glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER,GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    
    NSSize s = [image size];
    GLuint width = s.width;
    GLuint height = s.height;
    
    //GLuint width = CGImageGetWidth(image.CGImage);
    //GLuint height = CGImageGetHeight(image.CGImage);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    void *imageData = malloc(height * width * 4);
    CGContextRef context = CGBitmapContextCreate(imageData, width, height, 8, 4 * width, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    CGContextClearRect(context, CGRectMake(0, 0, width, height));
    CGContextTranslateCTM (context, 0, height);
    CGContextScaleCTM (context, 1.0, -1.0);
    
    CGImageSourceRef source;
    
    source = CGImageSourceCreateWithData((CFDataRef) [image TIFFRepresentation], NULL);
    CGImageRef maskRef =  CGImageSourceCreateImageAtIndex(source, 0, NULL);
    
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), maskRef);
    
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, imageData);
    int e = glGetError();
    NSLog(@"e = %i", e);
    // NOTE: At this point OpenGL has the texture in its own buffer.
    
    CGContextRelease(context);
    
    free(imageData);*/
    
    
	NSData *imageData = [image TIFFRepresentation];
	[self loadFromData: imageData
				toSize: size];
}

#endif

#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR

- (void) loadForGLKitFromData: (NSData *) data {
    
    [self loadForGLKitFromData: data
            originIsBottomLeft: NO];
}

/*
 * Loads a GLKit optimized texture info object from the image data provided.
 * NOTE: This method must be called from the main UI thread.
 */
- (void) loadForGLKitFromData: (NSData *) data originIsBottomLeft: (BOOL) originIsBottomLeft {
    
    if ([data length] == 0) {
        return;
    }
    
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys: [NSNumber numberWithBool: originIsBottomLeft], GLKTextureLoaderOriginBottomLeft,
                                                                        nil];
    
    NSError *error = nil;
    _textureInfo = [[GLKTextureLoader textureWithContentsOfData: data
                                                        options: options
                                                          error: &error] retain];
}

#endif

// NOTE: The below method is commented only because it has not been tested recently.  It may still work and you're free to try it.
/*
- (void) loadPvrtcImage: (NSString *) imageName_ withWidth: (GLsizei) width_ height: (GLsizei) height_ bitsPerPixel: (GLsizei) bpp_ alpha: (BOOL) alpha_ {
	
	GLuint textureArray[1];
	glGenTextures(1, &textureArray[0]);
	glBindTexture(GL_TEXTURE_2D, textureArray[0]);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
	
	NSString *path = [[NSBundle mainBundle] pathForResource: imageName_ ofType: @"pvrtc"];
	NSData *texData = [[NSData alloc] initWithContentsOfFile: path];
	
    GLenum format;

    if (alpha_) {
		
        format = (bpp_ == 4) ? GL_COMPRESSED_RGBA_PVRTC_4BPPV1_IMG
							 : GL_COMPRESSED_RGBA_PVRTC_2BPPV1_IMG;
		
    } else {
		
        format = (bpp_ == 4) ? GL_COMPRESSED_RGB_PVRTC_4BPPV1_IMG
							 : GL_COMPRESSED_RGB_PVRTC_2BPPV1_IMG;
    }

	
    glCompressedTexImage2D(GL_TEXTURE_2D,
						   0, // The mipmap level is always zero.
						   format,
						   width_,
						   height_,
						   0,
						   [texData length],
						   [texData bytes]);
	
	// TODO: this just assumes the above call worked.
	GLenum err = glGetError();
	if (err != GL_NO_ERROR) {
		
		NSLog(@"Error calling glCompressedTexImage2D. glError: 0x%04X", err);
	}
	
	textureId = textureArray[0];
	
	[texData release];
}
*/


#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR

#elif TARGET_OS_MAC

/*
 * Returns a CGRect in the middle of the sized image.
 *
 * width	The source width.
 * height	The source height.
 * size		The new width and height.
 */
+ (CGRect) bestRectForWidth: (CGFloat) width height: (CGFloat) height withSize: (NSSize) size {
	
	if (width == 0.0f || height == 0.0f) {
		return CGRectZero;
	}
	
	CGFloat aspectRatio = width / height;
	CGFloat height2 = size.width * (1.0f / aspectRatio);
	if (height > size.height) {
		// Not going to work.  Try matching the height...
		CGFloat width2 = size.height * aspectRatio;
		CGFloat x = (size.width - width2) / 2.0f;
		CGRect bestRect = CGRectMake(x, 0.0f, width2, size.height);
		return bestRect;
	}
	
	// Fits finely.
	CGFloat y = (size.height - height2) / 2.0f;
	CGRect bestRect = CGRectMake(0.0f, y, size.width, height2);
	return bestRect;
}

#endif


- (void) releaseTextureInMainThread {
    
#if TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR
    /*
     * NOTE: Apparently GLKTextureInfo has a leak of sorts.
     * Unless we proactively call the underlying OpenGL call
     * to release its inner texture info the object may NOT
     * do so on its own.
     *
     * Source: http://stackoverflow.com/questions/8720221/release-textures-glktextureinfo-objects-allocated-by-glktextureloader
     */
    GLuint name = [_textureInfo name];
    if (name > 0) {
        glDeleteTextures(1, &name);
    }
    JFRelease(_textureInfo);
#endif
	
	if (_textureId > 0) {
		// Unbind the texture from the video card's memory...
		glDeleteTextures(1, &_textureId);
	}
}

@end
