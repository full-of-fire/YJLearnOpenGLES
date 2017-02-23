//
//  ViewController.m
//  GLSL--01
//
//  Created by yangjie on 17/2/20.
//  Copyright © 2017年 yj. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

/** context */
@property (nonatomic,strong) EAGLContext *context;


/** programe */
@property (nonatomic,assign) GLuint shaderPrograme;


/** 颜色索引值 */
@property (nonatomic,assign) GLint vertexColor;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    _context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    [EAGLContext setCurrentContext:_context];
    
    
    GLKView *glView = (GLKView*)self.view;
    glView.context = _context;
    
    
    //创建定点数组
    GLfloat vVertexs[] = {
    
        0.5f,0.5f,0.0f,
        -0.5f,0.5f,0.0f,
        -0.5,-0.5f,0.0f,
    };
    
    //复制顶点数组到缓冲区
    GLuint buffer;
    glGenBuffers(1, &buffer);
    glBindBuffer(GL_ARRAY_BUFFER, buffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(vVertexs), vVertexs, GL_STATIC_DRAW);
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, sizeof(GLfloat)*3, NULL);
    
    
    
    // 创建自己的着色器
    
    [self createShaderProgram];
    
    
    
}


- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {

    //
    glClearColor(0.0f, 1.0f, 0.0f, 1.0f);
    
    glClear(GL_COLOR_BUFFER_BIT);
    
    
    glUniform4f(_vertexColor, 1.0, 0, 0, 1.0);
    
    //使用顶点着色器
    glUseProgram(_shaderPrograme);
    
    // 进行绘制
    glDrawArrays(GL_TRIANGLES, 0, 3);
    
}



- (void)createShaderProgram {

    //1. 创建定点着色器
    GLuint vertexShader;
    vertexShader = glCreateShader(GL_VERTEX_SHADER);
    //2.加载着色器字符串
    NSString *vertexPath = [[NSBundle mainBundle] pathForResource:@"Shader.vsh" ofType:nil];
    const GLchar *vertexSource =(const GLchar*) [[NSString stringWithContentsOfFile:vertexPath encoding:NSUTF8StringEncoding error:nil] UTF8String];
    //3.读取字符串到顶点着色器
    glShaderSource(vertexShader, 1, &vertexSource, NULL);
    
    //4.编译
    glCompileShader(vertexShader);
    //5.获取编译的status
    GLint status;
    glGetShaderiv(vertexShader, GL_COMPILE_STATUS, &status);
    
    if (status == 0) {
        
        NSLog(@"顶点编译失败");
        glDeleteShader(vertexShader);
        return;
    }
    
    
    //6.编译片段着色
    GLuint fragShader;
    fragShader = glCreateShader(GL_FRAGMENT_SHADER);
    NSString *fragPath = [[NSBundle mainBundle] pathForResource:@"Shader.fsh" ofType:nil];
    const GLchar*fragSource = (const GLchar*)[[NSString stringWithContentsOfFile:fragPath encoding:NSUTF8StringEncoding error:nil] UTF8String];
    glShaderSource(fragShader, 1, &fragSource, NULL);
    glCompileShader(fragShader);
    
    glGetShaderiv(fragShader, GL_COMPILE_STATUS, &status);
    if (status == 0) {
        NSLog(@"片段编译失败");
        glDeleteShader(fragShader);
        return;
    }
    
    
    
    //7. 创建programe
    _shaderPrograme = glCreateProgram();
    
    //8.将编译好的着色连接到程序
    glAttachShader(_shaderPrograme, vertexShader);
    glAttachShader(_shaderPrograme, fragShader);
    
    //9绑定位置属性
    glBindAttribLocation(_shaderPrograme, 0, "position");
    
    //10.链接
    glLinkProgram(_shaderPrograme);
    
    //11.检查链接的status
     glGetProgramiv(_shaderPrograme, GL_LINK_STATUS, &status);
    
    if (status == 0) {
        
        if (vertexShader) {
            
            glDeleteShader(vertexShader);
            vertexShader = 0;
        }
        
        if (fragShader) {
            
            glDeleteShader(fragShader);
            fragShader = 0;
        }
        
        if (_shaderPrograme) {
            
            glDeleteProgram(_shaderPrograme);
            _shaderPrograme = 0;
        }
        
        return;
    }
    
    
    //12.获取颜色索引值
    _vertexColor = glGetUniformLocation(_shaderPrograme, "color");
    
    
    
    
    
    
    
    
}






@end
