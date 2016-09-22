//
//  MyEAGLContext.m
//  OpenGLES_Ch3_3
//
//  Created by jiaxiang on 16/9/22.
//  Copyright © 2016年 jiaxiang. All rights reserved.
//

#import "MyEAGLContext.h"

@implementation MyEAGLContext

-(void) setClearColor:(GLKVector4)clearColorRGBA {
    _clearColor = clearColorRGBA;
    
    NSAssert(self == [[self class] currentContext], @"Receiving context required to be current context!");
    
    glClearColor(clearColorRGBA.r, clearColorRGBA.g, clearColorRGBA.b, clearColorRGBA.a);
}

-(void) clear:(GLbitfield)mask {
    glClear(mask);
}


-(void) enable:(GLenum)capability {
    NSAssert(self == [[self class] currentContext], @"Receiving context required to be current context!");
    glEnable(capability);
}

-(void) disable:(GLenum)capability {
    NSAssert(self == [[self class] currentContext], @"Receiving context required to be current context!");
    glDisable(capability);
}

-(void) setBlendSourceFunction:(GLenum)sfactor destinationFunction:(GLenum)dfactor {
    NSAssert(self == [[self class] currentContext], @"Receiving context required to be current context!");
    glBlendFunc(sfactor, dfactor);
}

@end
