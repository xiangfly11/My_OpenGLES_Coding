//
//  ViewController.m
//  OpenGLES_Ch3_3
//
//  Created by jiaxiang on 16/9/22.
//  Copyright © 2016年 jiaxiang. All rights reserved.
//

#import "ViewController.h"
#import "MyEAGLContext.h"

typedef struct {
    GLKVector3 positionCoords;
    GLKVector2 textureCoords;
} SceneVertex;

static SceneVertex vertices[] =
{
    {{-0.5f, -0.5f, 0.0f}, {0.0f, 0.0f}}, // lower left corner
    {{ 0.5f, -0.5f, 0.0f}, {1.0f, 0.0f}}, // lower right corner
    {{-0.5f,  0.5f, 0.0f}, {0.0f, 1.0f}}, // upper left corner
};

static const SceneVertex defaultVertices[] =
{
    {{-0.5f, -0.5f, 0.0f}, {0.0f, 0.0f}},
    {{ 0.5f, -0.5f, 0.0f}, {1.0f, 0.0f}},
    {{-0.5f,  0.5f, 0.0f}, {0.0f, 1.0f}},
};

static GLKVector3 movementVectors[3] = {
    {-0.02f,  -0.01f, 0.0f},
    {0.01f,  -0.005f, 0.0f},
    {-0.01f,   0.01f, 0.0f},
};


@interface GLKEffectPropertyTexture (AGLKAdditions)

- (void)aglkSetParameter:(GLenum)parameterID
                   value:(GLint)value;

@end

@implementation GLKEffectPropertyTexture (AGLKAdditions)

- (void)aglkSetParameter:(GLenum)parameterID
                   value:(GLint)value
{
    glBindTexture(self.target, self.name);
    
    glTexParameteri(
                    self.target,
                    parameterID, 
                    value);
}

@end



@interface ViewController () {
    GLuint bufferName;;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.preferredFramesPerSecond = 60;
    self.shouldUseAnimation = YES;
    self.shouldRepeatTexture = YES;
    
    GLKView *view = (GLKView *) self.view;
    NSAssert([view isKindOfClass:[GLKView class]], @"Controller's view is not GLKView");
    
    view.context = [[MyEAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    [MyEAGLContext setCurrentContext:view.context];
    
    self.baseEffect = [[GLKBaseEffect alloc] init];
    self.baseEffect.useConstantColor = GL_TRUE;
    self.baseEffect.constantColor = GLKVector4Make(1.0f, 1.0f, 1.0f, 1.0f);
    
    ((MyEAGLContext *) view.context).clearColor = GLKVector4Make(0.0f, 0.0f, 0.0f, 1.0f);
    
    
    glGenBuffers(1, &bufferName);
    glBindBuffer(GL_ARRAY_BUFFER, bufferName);
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_DYNAMIC_DRAW);
    
    CGImageRef imageRef = [[UIImage imageNamed:@"grid.png"] CGImage];
    GLKTextureInfo *textureInfo = [GLKTextureLoader textureWithCGImage:imageRef options:nil error:NULL];
    
    self.baseEffect.texture2d0.name = textureInfo.name;
    self.baseEffect.texture2d0.target = textureInfo.target;
    
}


-(void) glkView:(GLKView *)view drawInRect:(CGRect)rect {
    [self.baseEffect prepareToDraw];
    
    [(MyEAGLContext *) view.context  clear:GL_COLOR_BUFFER_BIT];
    
    glBindBuffer(GL_ARRAY_BUFFER, bufferName);
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, sizeof(SceneVertex), NULL+ offsetof(SceneVertex, positionCoords));
    
    glBindBuffer(GL_ARRAY_BUFFER, bufferName);
    glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
    glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, sizeof(SceneVertex), NULL + offsetof(SceneVertex, textureCoords));
    
    glDrawArrays(GL_TRIANGLES, 0, 3);
    
    
}

- (void)updateTextureParameters
{
    [self.baseEffect.texture2d0
     aglkSetParameter:GL_TEXTURE_WRAP_S
     value:(self.shouldRepeatTexture ?
            GL_REPEAT : GL_CLAMP_TO_EDGE)];
    
    [self.baseEffect.texture2d0
     aglkSetParameter:GL_TEXTURE_MAG_FILTER
     value:(self.shouldUseLinearFilter ?
            GL_LINEAR : GL_NEAREST)];
}

- (void)updateAnimatedVertexPositions
{
    if(_shouldUseAnimation)
    {  // Animate the triangles vertex positions
        int    i;  // by convention, 'i' is current vertex index
        
        for(i = 0; i < 3; i++)
        {
            vertices[i].positionCoords.x += movementVectors[i].x;
            if(vertices[i].positionCoords.x >= 1.0f ||
               vertices[i].positionCoords.x <= -1.0f)
            {
                movementVectors[i].x = -movementVectors[i].x;
            }
            vertices[i].positionCoords.y += movementVectors[i].y;
            if(vertices[i].positionCoords.y >= 1.0f ||
               vertices[i].positionCoords.y <= -1.0f)
            {
                movementVectors[i].y = -movementVectors[i].y;
            }
            vertices[i].positionCoords.z += movementVectors[i].z;
            if(vertices[i].positionCoords.z >= 1.0f ||
               vertices[i].positionCoords.z <= -1.0f)
            {
                movementVectors[i].z = -movementVectors[i].z;
            }
        }
    }
    else
    {  // Restore the triangle vertex positions to defaults
        int    i;  // by convention, 'i' is current vertex index
        
        for(i = 0; i < 3; i++)
        {
            vertices[i].positionCoords.x =
            defaultVertices[i].positionCoords.x;
            vertices[i].positionCoords.y =
            defaultVertices[i].positionCoords.y;
            vertices[i].positionCoords.z =
            defaultVertices[i].positionCoords.z;
        }
    }
    
    
    {  // Adjust the S texture coordinates to slide texture and
        // reveal effect of texture repeat vs. clamp behavior
        int    i;  // 'i' is current vertex index
        
        for(i = 0; i < 3; i++)
        {
            vertices[i].textureCoords.s =
            (defaultVertices[i].textureCoords.s + 
             _sCoordinateOffset);
        }
    }
}


- (void)update
{
    [self updateAnimatedVertexPositions];
    [self updateTextureParameters];
    
    glBindBuffer(GL_ARRAY_BUFFER, bufferName);
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_DYNAMIC_DRAW);
}


-(void) viewDidUnload {
    GLKView *view = (GLKView *) self.view;
    [MyEAGLContext setCurrentContext:view.context];
    
    ((GLKView *) self.view).context = nil;
    [MyEAGLContext setCurrentContext:nil];
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

- (IBAction)takeLinearFilter:(UISwitch *)sender {
    self.shouldUseLinearFilter = [sender isOn];
}

- (IBAction)takeAnimation:(UISwitch *)sender {
    self.shouldUseAnimation = [sender isOn];
}

- (IBAction)takeRepeatTexture:(UISwitch *)sender {
    self.shouldRepeatTexture = [sender isOn];
}

- (IBAction)takeSCoordinateOffset:(UISlider *)sender {
    self.sCoordinateOffset = [sender value];
}
@end
