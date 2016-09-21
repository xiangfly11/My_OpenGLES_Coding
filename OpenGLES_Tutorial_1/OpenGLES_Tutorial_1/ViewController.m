//
//  ViewController.m
//  OpenGLES_Tutorial_1
//
//  Created by jiaxiang on 16/9/21.
//  Copyright © 2016年 jiaxiang. All rights reserved.
//

#import "ViewController.h"

typedef struct {
    GLKVector3 positionCoords;
    GLKVector2 textureCoords;
}SceneVertex;

static const SceneVertex vertices[] = {
    {{-0.5f,-0.5f,0.0f},{0.0f,0.0f}},
    {{0.5f,-0.5f,0.0f},{1.0f,0.0f}},
    {{-0.5f,0.5f,0.0f},{0.0f,1.0f}},
    {{0.5f,0.5f,0.0f},{1.0f,1.0f}}
};

GLfloat squareVertexData[] =
{
    0.5, -0.5, 0.0f,    1.0f, 0.0f, //右下
    -0.5, 0.5, 0.0f,    0.0f, 1.0f, //左上
    -0.5, -0.5, 0.0f,   0.0f, 0.0f, //左下
    0.5, 0.5, -0.0f,    1.0f, 1.0f, //右上
};

static const GLuint indices[] = {
    0,1,2,
    1,3,0
};

@interface ViewController ()

@property (nonatomic,strong) GLKBaseEffect *baseEffect;
@property (nonatomic,strong) EAGLContext *myContext;
@property (nonatomic,assign) int myCount;
@end

@implementation ViewController

-(void) viewDidLoad {
    GLKView *view = (GLKView *) self.view;
    self.myContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    view.context = self.myContext;
    [EAGLContext setCurrentContext:self.myContext];
    
    self.myCount = sizeof(indices) / sizeof(GLuint);
    
    GLuint nameBuffer1;
    glGenBuffers(1, &nameBuffer1);
    glBindBuffer(GL_ARRAY_BUFFER, nameBuffer1);
    glBufferData(GL_ARRAY_BUFFER, sizeof(squareVertexData), squareVertexData, GL_STATIC_DRAW);
    GLsizei count = sizeof(vertices) / sizeof(SceneVertex);
    GLsizeiptr bufferSizeBytes = sizeof(SceneVertex) * count;
//    glBufferData(GL_ARRAY_BUFFER, bufferSizeBytes, vertices, GL_STATIC_DRAW);
    
    GLuint nameBuffer2;
    glGenBuffers(1, &nameBuffer2);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, nameBuffer2);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(indices), indices, GL_STATIC_DRAW);
    
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, sizeof(GLfloat) * 5, (GLfloat *) NULL  + 0);
//    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, sizeof(SceneVertex), (GLfloat *) NULL + offsetof(SceneVertex, positionCoords));
   
    glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
    glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, sizeof(GLfloat) * 5, (GLfloat*) NULL + 3);
    
    NSString* filePath = [[NSBundle mainBundle] pathForResource:@"for_test" ofType:@"jpg"];
    NSDictionary* options = [NSDictionary dictionaryWithObjectsAndKeys:@(1), GLKTextureLoaderOriginBottomLeft, nil];
    GLKTextureInfo* textureInfo = [GLKTextureLoader textureWithContentsOfFile:filePath options:options error:nil];
    
    self.baseEffect = [[GLKBaseEffect alloc] init];
    self.baseEffect.texture2d0.enabled = GL_TRUE;
    self.baseEffect.texture2d0.name = textureInfo.name;
    
    
}

-(void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    glClearColor(0.3f, 0.6f, 1.0f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    //启动着色器
    [self.baseEffect prepareToDraw];
    glDrawElements(GL_TRIANGLES, self.myCount, GL_UNSIGNED_INT, 0);
}



@end
