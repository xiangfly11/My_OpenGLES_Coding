//
//  ViewController.m
//  OpenGLES_Ch3_4
//
//  Created by jiaxiang on 16/9/23.
//  Copyright © 2016年 jiaxiang. All rights reserved.
//

#import "ViewController.h"
#import "MyEAGLContext.h"

typedef struct {
    GLKVector3 positionCoords;
    GLKVector2 textureCoords;
}SceneVertex;

static const SceneVertex vertices[] = {
    {{-1.0f,-0.67f,0.0f},{0.0f,0.0f}}, // first trangle
    {{1.0f,-0.67f,0.0f},{1.0f,0.0f}},
    {{-1.0f,0.67f,0.0f},{0.0f,1.0f}},
    
    {{1.0f,-0.67f,0.0f},{1.0f,0.0f}}, //second trangle
    {{-1.0f,0.67f,0.0f},{0.0f,1.0f}},
    {{1.0f,0.67f,0.0f},{1.0f,1.0f}},
};

@interface ViewController ()

@property (nonatomic,assign) GLuint bufferName;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    GLKView *view = (GLKView *) self.view;
    NSAssert( [view isKindOfClass:[GLKView class]], @"Controller's view is required to be GLKView");
    
    view.context = [[MyEAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    [MyEAGLContext setCurrentContext: view.context];
    
    self.baseEffect = [[GLKBaseEffect alloc] init];
    self.baseEffect.useConstantColor = GL_TRUE;
    self.baseEffect.constantColor = GLKVector4Make(1.0f, 1.0f, 1.0f, 1.0f);
    
    ((MyEAGLContext *) view.context).clearColor = GLKVector4Make(0.0f, 0.0f, 0.0f, 1.0f);
    
    glGenBuffers(1, &_bufferName);
    glBindBuffer(GL_ARRAY_BUFFER, _bufferName);
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);
    
    CGImageRef imageRef0 = [[UIImage imageNamed:@"leaves.gif"] CGImage];
    self.textureInfo0 = [GLKTextureLoader textureWithCGImage:imageRef0 options:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],GLKTextureLoaderOriginBottomLeft, nil] error:nil];
    
    CGImageRef imageRef1 = [[UIImage imageNamed:@"beetle.png"] CGImage];
    self.textureInfo1 = [GLKTextureLoader textureWithCGImage:imageRef1 options:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],GLKTextureLoaderOriginBottomLeft, nil] error:nil];
    
    glEnable(GL_BLEND);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
}



-(void) glkView:(GLKView *)view drawInRect:(CGRect)rect {
    [(MyEAGLContext *) view.context clear:GL_COLOR_BUFFER_BIT];
    
    glBindBuffer(GL_ARRAY_BUFFER, _bufferName);
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, sizeof(SceneVertex), NULL + offsetof(SceneVertex, positionCoords));
    
    glBindBuffer(GL_ARRAY_BUFFER, _bufferName);
    glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
    glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, sizeof(SceneVertex), NULL + offsetof(SceneVertex, textureCoords));
    
    self.baseEffect.texture2d0.name = self.textureInfo0.name;
    self.baseEffect.texture2d0.target = self.textureInfo0.target;
    [self.baseEffect prepareToDraw];
    
    glDrawArrays(GL_TRIANGLES, 0, sizeof(vertices) / sizeof(SceneVertex));
    
    self.baseEffect.texture2d0.name = self.textureInfo1.name;
    self.baseEffect.texture2d0.target = self.textureInfo1.target;
    [self.baseEffect prepareToDraw];
    
    glDrawArrays(GL_TRIANGLES, 0, sizeof(vertices) / sizeof(SceneVertex));
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
