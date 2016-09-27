//
//  ViewController.h
//  OpenGLES_Ch5_2
//
//  Created by jiaxiang on 16/9/27.
//  Copyright © 2016年 jiaxiang. All rights reserved.
//

#import <GLKit/GLKit.h>
@class AGLKVertexAttribArrayBuffer;

@interface ViewController : GLKViewController

@property (nonatomic,strong) GLKBaseEffect *baseEffect;
@property (nonatomic,strong) AGLKVertexAttribArrayBuffer *vertexPositionBuffer;
@property (nonatomic,strong) AGLKVertexAttribArrayBuffer *vertexNormalBuffer;
@property (nonatomic,strong) AGLKVertexAttribArrayBuffer *textureCoordsBuffer;
@end
