//
// JFOpenGLTextureImage.m
// JFCommon
//
// Created by Jason Fuerstenberg on 09/11/03.
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

@synthesize alphaValue = _alphaValue;


- (void) dealloc {
	
	// NOTE: The OpenGL texture has to be released from the main thread.
	[self performSelectorOnMainThread: @selector(releaseTextureInMainThread)
						   withObject: nil
						waitUntilDone: YES];
	
	[super dealloc];
}


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
			CGContextRef imageContext = CGBitmapContextCreate(textureData,
															  imageW,
															  imageH,
															  8,
															  imageW << 2,
															  CGImageGetColorSpace(imageRef),
															  kCGImageAlphaPremultipliedLast);
			
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
				
				
				// when texture area is small, bilinear filter the closest mipmap
				glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
				// when texture area is large, bilinear filter the original
				glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
				glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, size.width, size.height, 0, GL_RGBA, GL_UNSIGNED_BYTE, textureData);
				
				// NOTE: At this point OpenGL has the texture in its own buffer.
				
				GLenum err = glGetError();
				if (err != GL_NO_ERROR) {
					NSUInteger freeMemory = [[JFMemoryManager sharedManager] freeMemory];
					if (err == GL_INVALID_OPERATION && freeMemory < 1024 * 1024 * 10) {
						// Might too little memory to create the texture.
						NSLog(@"Could not create OpenGL texture due to error GL_INVALID_OPERATION.  May be related to only %i bytes of free memory remaining.", freeMemory);
					} else {
						NSLog(@"glError: 0x%04X", err);
						NSLog(@"Texture image dimension = %f x %f", size.width, size.height);
					}
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


/*
 * Loads a texture from the given image to a particular size.
 *
 * image	The image from which the texture will be loaded.
 * size		The width and height of the resulting texture.
 */
- (void) loadFromImage: (NSImage *) image toSize: (NSSize) size {
	
	NSData *imageData = [image TIFFRepresentation];
	[self loadFromData: imageData
				toSize: size];
}

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


- (void) releaseTextureInMainThread {
	
	//NSLog(@"RELEASING OPENGL TEXTURE ID: %i", _textureId);
	if (_textureId > 0) {
		// Unbind the texture from the video card's memory...
		glDeleteTextures(1, &_textureId);
	}
}

@end
