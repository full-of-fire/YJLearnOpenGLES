//
//  YJShaderManager.m
//  CAEAGLLayer
//
//  Created by yj on 17/2/23.
//  Copyright © 2017年 yj. All rights reserved.
//

#import "YJShaderManager.h"

@interface YJShaderManager ()

@property (assign,nonatomic)GLuint shaderPrograme; // 着色器程序

@end

@implementation YJShaderManager
- (instancetype)init
{
    self = [super init];
    if (self) {
        
        
        [self setUpPrograme];
        
        
    }
    return self;
}

- (GLuint)shaderProgam {

    
    return _shaderPrograme;
}

- (BOOL)useProgram {

    if (_shaderPrograme == 0) {
        
        return NO;
    }
    
    glUseProgram(_shaderPrograme);
    return YES;
}



#pragma mark - 创建着色器程序
- (void)setUpPrograme {

    //1.创建着色器
    GLuint vertexShader;
    GLuint fragShader;
    vertexShader = glCreateShader(GL_VERTEX_SHADER);
    fragShader = glCreateShader(GL_FRAGMENT_SHADER);
    //2.编译
    NSString *vertexPath = [[NSBundle mainBundle] pathForResource:@"Shader.vsh" ofType:nil];
    NSString *fragPath = [[NSBundle mainBundle] pathForResource:@"Shader.fsh" ofType:nil];
    [self compileShader:vertexShader type:GL_VERTEX_SHADER filePath:vertexPath];
    [self compileShader:fragShader type:GL_FRAGMENT_SHADER filePath:fragPath];
    
    //3.创建着色器程序
    _shaderPrograme = glCreateProgram();
    
    //4.attach
    glAttachShader(_shaderPrograme, vertexShader);
    glAttachShader(_shaderPrograme, fragShader);
    
    
    //释放不需要的shader
    glDeleteShader(vertexShader);
    glDeleteShader(fragShader);
    //5.link
    glLinkProgram(_shaderPrograme);
    
    //6.获取链接状态
    GLint stauts;
    glGetProgramiv(_shaderPrograme, GL_LINK_STATUS, &stauts);
    if (stauts == 0) {
        NSLog(@"连接失败");
        glDeleteProgram(_shaderPrograme);
        _shaderPrograme = 0;
        return;
    }
    
}



#pragma mark - 编译着色器
- (void)compileShader:(GLuint)shader type:(GLenum)type filePath:(NSString*)filePath {

    if (filePath == nil || filePath.length == 0) {
        return;
    }
    //1.读取字符串
    NSString *content = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    if (content == nil || content.length == 0) {
        
        return;
    }
    const GLchar* source = (GLchar*)[content UTF8String];
    glShaderSource(shader, 1, &source, NULL);
    
    //2.编译
    glCompileShader(shader);
    
    //3.查询编译状态
    GLint status;
    glGetShaderiv(shader, GL_COMPILE_STATUS, &status);
    if (status == 0) {
        NSLog(@"编译失败");
        return;
    }
    
    
}



@end
