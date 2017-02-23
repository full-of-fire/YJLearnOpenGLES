//
//  ViewController.m
//  OpenGLES-helloworld
//
//  Created by yangjie on 17/2/18.
//  Copyright © 2017年 yj. All rights reserved.
//

#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>
@interface ViewController ()

/** glContext */
@property (nonatomic,strong) EAGLContext *glContext;


/** base */
@property (nonatomic,strong) GLKBaseEffect *baseEffect;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 初始化gl上下文
    _glContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
      [EAGLContext setCurrentContext:_glContext];

    // view
    GLKView *glView = (GLKView*)self.view;
    glView.context = _glContext;
    
    
    GLfloat vVerter[] = {
    
        0.5f,0.5f,0.0f,  1.0f,1.0f,
        -0.5f,0.5f,0.0f,   1.0f,0.0f,
         -0.5f,-0.5f,0.0f, 0.0f,0.0f,
         0.5f,-0.5f,0.0f, 1.0f,0.0f,
        
    
    };
    
 
    GLuint buffer;
    
    glGenBuffers(1, &buffer);
    glBindBuffer(GL_ARRAY_BUFFER, buffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(vVerter), vVerter, GL_STATIC_DRAW);
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, sizeof(GLfloat)*5, NULL);
    
    
    glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
    glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, sizeof(GLfloat)*5, (char*)NULL+sizeof(GLfloat)*3);
    
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"test.png" ofType:nil];
    
    
//    GLKTextureInfo *textureInfo = [GLKTextureInfo ]
    
   GLKTextureInfo *info =  [GLKTextureLoader textureWithContentsOfFile:path
                                      options:nil
                                        error:nil];
    
    
    if (!info) {
        
        NSLog(@"加载纹理出错了");
    }
    
    _baseEffect = [[GLKBaseEffect alloc] init];
//    _baseEffect.light0.enabled = GL_TRUE;
//    _baseEffect.light0.diffuseColor =  GLKVector4Make(0.0, 0.0, 0.0, 1.0);
    _baseEffect.texture2d0.enabled = GL_TRUE;
    _baseEffect.texture2d0.name = info.name;

  

 
    
    
    
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect{

    glClearColor(1.0, 0.0, 0.0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT);
    
    
    [_baseEffect prepareToDraw];
    
    glDrawArrays(GL_TRIANGLE_FAN, 0, 4);
    
    
}


@end
