//
//  MyEAGLContext.m
//  OpenGLES_Ch3_4
//
//  Created by jiaxiang on 16/9/23.
//  Copyright © 2016年 jiaxiang. All rights reserved.
//

#import "MyEAGLContext.h"

@implementation MyEAGLContext

-(void) setClearColor:(GLKVector4)clearColorRGBA {
    _clearColor = clearColorRGBA;
    NSAssert([self  isKindOfClass:[EAGLContext class]], @"Receiving context is required to be EAGLContext");
    
    glClearColor(clearColorRGBA.r, clearColorRGBA.g, clearColorRGBA.b, clearColorRGBA.a);

}

-(void) clear:(GLbitfield)mask {
    glClear(mask);
}

-(void) enable:(GLenum)capability {
    NSAssert([self  isKindOfClass:[EAGLContext class]], @"Receiving context is required to be EAGLContext");
    
    glEnable(capability);
}

-(void) disable:(GLenum)capability {
    NSAssert([self  isKindOfClass:[EAGLContext class]], @"Receiving context is required to be EAGLContext");
    
    glDisable(capability);
}

-(void) setBlendSourceFunction:(GLenum)sfactor destinationFunction:(GLenum)dfactor {
    NSAssert([self  isKindOfClass:[EAGLContext class]], @"Receiving context is required to be EAGLContext");
    glBlendFunc(sfactor, dfactor);
}
@end
