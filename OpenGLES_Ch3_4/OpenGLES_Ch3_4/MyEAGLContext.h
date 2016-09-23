//
//  MyEAGLContext.h
//  OpenGLES_Ch3_4
//
//  Created by jiaxiang on 16/9/23.
//  Copyright © 2016年 jiaxiang. All rights reserved.
//

#import <GLKit/GLKit.h>

@interface MyEAGLContext : EAGLContext

@property (nonatomic,assign) GLKVector4 clearColor;

-(void) setClearColor:(GLKVector4)clearColorRGBA;
-(void) clear:(GLbitfield) mask;
-(void) enable:(GLenum) capability;
-(void) disable:(GLenum) capability;
-(void) setBlendSourceFunction:(GLenum) sfactor destinationFunction:(GLenum) dfactor;

@end
