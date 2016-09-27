//
//  ViewController.m
//  OpenGLES_Ch5_2
//
//  Created by jiaxiang on 16/9/27.
//  Copyright © 2016年 jiaxiang. All rights reserved.
//

#import "ViewController.h"
#import "AGLKVertexAttribArrayBuffer.h"
#import "sphere.h"
#import "MyEAGLContext.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    GLKView *view = (GLKView *) self.view;
    NSAssert([view isKindOfClass:[GLKView class]], @"Controller's view should  be GLKView");
    
    view.drawableDepthFormat = GLKViewDrawableDepthFormat16;  //Setting depth format, use depth buffer to store rendering result
    view.context = [[MyEAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    [MyEAGLContext setCurrentContext:view.context];
    
    /* Setting base effect to render images
     * 1,initial the base effect 
     * 2,assign value for diffuseColor which will show light effect 
     * 3,assign value for position which is light position in the image
     * 4,assign value for ambientColor whixh will show enviroment light
    */
    self.baseEffect = [[GLKBaseEffect alloc] init];
    self.baseEffect.light0.enabled = GL_TRUE;
    self.baseEffect.light0.diffuseColor = GLKVector4Make(0.7f, 0.7f, 0.7f, 1.0f);
    self.baseEffect.light0.position = GLKVector4Make(1.0f,0.0f,-0.8f,0.0f);
    self.baseEffect.light0.ambientColor = GLKVector4Make(0.2f, 0.2f, 0.2f, 0.2f);
    
    
    CGImageRef imageRef = [[UIImage imageNamed:@"Earth512x256.jpg"] CGImage];
    GLKTextureInfo *textureInfo = [GLKTextureLoader textureWithCGImage:imageRef options:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],GLKTextureLoaderOriginBottomLeft, nil] error:nil];
    self.baseEffect.texture2d0.name = textureInfo.name;
    self.baseEffect.texture2d0.target = textureInfo.target;
    
    ((MyEAGLContext *) view.context).clearColor = GLKVector4Make(0.0f, 0.0f, 0.0f, 1.0f);
    
    self.vertexPositionBuffer = [[AGLKVertexAttribArrayBuffer alloc]
                                 initWithAttribStride:(3 * sizeof(GLfloat))
                                 numberOfVertices:sizeof(sphereVerts) / (3 * sizeof(GLfloat))
                                 bytes:sphereVerts
                                 usage:GL_STATIC_DRAW];
    self.vertexNormalBuffer = [[AGLKVertexAttribArrayBuffer alloc]
                               initWithAttribStride:(3 * sizeof(GLfloat))
                               numberOfVertices:sizeof(sphereNormals) / (3 * sizeof(GLfloat))
                               bytes:sphereNormals
                               usage:GL_STATIC_DRAW];
    self.textureCoordsBuffer = [[AGLKVertexAttribArrayBuffer alloc]
                                     initWithAttribStride:(2 * sizeof(GLfloat))
                                     numberOfVertices:sizeof(sphereTexCoords) / (2 * sizeof(GLfloat))
                                     bytes:sphereTexCoords
                                     usage:GL_STATIC_DRAW]; 
    
    glEnable(GL_DEPTH_TEST);

    
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    [self.baseEffect prepareToDraw];
    
    // Clear back frame buffer (erase previous drawing)
    [(MyEAGLContext *)view.context
     clear:GL_COLOR_BUFFER_BIT|GL_DEPTH_BUFFER_BIT];
    
    [self.vertexPositionBuffer
     prepareToDrawWithAttrib:GLKVertexAttribPosition
     numberOfCoordinates:3
     attribOffset:0
     shouldEnable:YES];
    [self.vertexNormalBuffer
     prepareToDrawWithAttrib:GLKVertexAttribNormal
     numberOfCoordinates:3
     attribOffset:0
     shouldEnable:YES];
    [self.textureCoordsBuffer
     prepareToDrawWithAttrib:GLKVertexAttribTexCoord0
     numberOfCoordinates:2
     attribOffset:0
     shouldEnable:YES];
    
    // Scale the Y coordinate based on the aspect ratio of the
    // view's Layer which matches the screen aspect ratio for
    // this example
    const GLfloat  aspectRatio =
    (GLfloat)view.drawableWidth / (GLfloat)view.drawableHeight;
    
    self.baseEffect.transform.projectionMatrix =
    GLKMatrix4MakeScale(1.0f, aspectRatio, 1.0f);
    
    // Draw triangles using vertices in the prepared vertex
    // buffers
    [AGLKVertexAttribArrayBuffer
     drawPreparedArraysWithMode:GL_TRIANGLES
     startVertexIndex:0
     numberOfVertices:sphereNumVerts];
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
