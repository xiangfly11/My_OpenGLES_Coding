//
//  MyViewController.h
//  OpenGLES_Ch2_1
//
//  Created by Jiaxiang Li on 16/9/3.
//  Copyright © 2016年 Jiaxiang Li. All rights reserved.
//

#import <GLKit/GLKit.h>

@interface MyViewController : GLKViewController {
      GLuint vertexBufferID;
}

@property (nonatomic,strong) GLKBaseEffect *baseEffect;
@end
