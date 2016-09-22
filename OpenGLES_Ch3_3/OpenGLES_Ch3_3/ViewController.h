//
//  ViewController.h
//  OpenGLES_Ch3_3
//
//  Created by jiaxiang on 16/9/22.
//  Copyright © 2016年 jiaxiang. All rights reserved.
//

#import <GLKit/GLKit.h>

@interface ViewController : GLKViewController

@property (nonatomic,strong) GLKBaseEffect *baseEffect;
@property (nonatomic,assign) BOOL shouldUseLinearFilter;
@property (nonatomic,assign) BOOL shouldUseAnimation;
@property (nonatomic,assign) BOOL shouldRepeatTexture;
@property (nonatomic,assign) GLfloat sCoordinateOffset;

- (IBAction)takeLinearFilter:(UISwitch *)sender;
- (IBAction)takeAnimation:(UISwitch *)sender;
- (IBAction)takeRepeatTexture:(UISwitch *)sender;
- (IBAction)takeSCoordinateOffset:(UISlider *)sender;

@end
