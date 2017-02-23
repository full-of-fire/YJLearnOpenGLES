//
//  YJOpenGLView.m
//  CAEAGLLayer
//
//  Created by yj on 17/2/23.
//  Copyright © 2017年 yj. All rights reserved.
//

#import "YJOpenGLView.h"
#import <OpenGLES/ES2/gl.h>
#import "YJShaderManager.h"
@interface YJOpenGLView ()

@property (strong,nonatomic) EAGLContext *context;

@property (strong,nonatomic) CAEAGLLayer *glLayer;

@property (assign,nonatomic) GLuint shaderProgram; // 着色器程序

@property (assign,nonatomic) GLuint colorRendrBuffer; // 渲染缓冲区

@property (assign,nonatomic) GLuint colorFrameBuffer; // 帧缓冲区


@property (assign,nonatomic) GLuint colorIndex; //颜色位置索引



@end

@implementation YJOpenGLView

+ (Class)layerClass {

    return [CAEAGLLayer class];
}


- (void)layoutSubviews {

    [super layoutSubviews];
    

    
    //1.
    [self setupLayer];
    //2.
    _context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    [EAGLContext setCurrentContext:_context];

    [self diposeRenderBufferAndFrameBuffer];
    
    
//    3.创建颜色缓冲区
    glGenRenderbuffers(1, &_colorRendrBuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, _colorRendrBuffer);
    //为颜色缓冲区分配存储空间
    [_context renderbufferStorage:GL_RENDERBUFFER fromDrawable:_glLayer];
//
    //4.创建帧缓冲
    GLuint frameBuffer;
    glGenFramebuffers(1, &frameBuffer);
    self.colorFrameBuffer = frameBuffer;
    glBindFramebuffer(GL_FRAMEBUFFER, self.colorFrameBuffer);
    // 将 _colorRenderBuffer 装配到 GL_COLOR_ATTACHMENT0 这个装配点上
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, self.colorFrameBuffer);
    
    
    // 5.创建着色器程序
    _shaderProgram = [[[YJShaderManager alloc] init] shaderProgam];
   
    // 6.设置数据
    [self setUpDataSource];
    
    //渲染
     [self render];
}


- (void)setupLayer
{
    _glLayer = (CAEAGLLayer*) self.layer;
    //设置放大倍数
    [self setContentScaleFactor:[[UIScreen mainScreen] scale]];
    
    // CALayer 默认是透明的，必须将它设为不透明才能让其可见
    _glLayer.opaque = YES;
    
    // 设置描绘属性，在这里设置不维持渲染内容以及颜色格式为 RGBA8
     _glLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:
                                          [NSNumber numberWithBool:NO], kEAGLDrawablePropertyRetainedBacking, kEAGLColorFormatRGBA8, kEAGLDrawablePropertyColorFormat, nil];
}




- (void)diposeRenderBufferAndFrameBuffer {

    glDeleteRenderbuffers(1, &_colorRendrBuffer);
    _colorRendrBuffer = 0;
    glDeleteFramebuffers(1, &_colorFrameBuffer);
    _colorFrameBuffer =0;
}


#pragma mark - 设置顶点和纹理
- (void)setUpDataSource {

    GLfloat vVertex[] = {
        
        0.5f,0.5f,0.0,  1.0f,1.0f,
        -0.5f,0.5f,0.0, 0.0f,1.0f,
        -0.5f,-0.5f,0.0, 0.0f,0.0f,
        0.5f,-0.5f,0.0,  1.0f,0.0f,
    };
    
    GLuint buffer;
    glGenBuffers(1, &buffer);
    glBindBuffer(GL_ARRAY_BUFFER, buffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(vVertex), vVertex, GL_STATIC_DRAW);
    
    // 获取位置索引
    GLuint positon = glGetAttribLocation(_shaderProgram, "position");
    glEnableVertexAttribArray(positon);
    glVertexAttribPointer(positon, 3, GL_FLOAT, GL_FALSE, sizeof(GLfloat)*5, NULL);
    
    GLuint textureIndex = glGetAttribLocation(_shaderProgram, "textureCoordinate");
    glEnableVertexAttribArray(textureIndex);
    glVertexAttribPointer(textureIndex, 2, GL_FLOAT, GL_FALSE, sizeof(GLfloat)*5, (GLfloat*)NULL+3);
    
    
    //获取颜色索引
//    GLuint colorIndex = glGetUniformLocation(_shaderProgram, "color");
//    _colorIndex = colorIndex;

    
    
   
    
    //加载纹理参数
    [self setupTexture:@"for_test.png"];
    
}






#pragma mark - 渲染
- (void)render {

    
    glClearColor(0, 1.0, 0.0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT);
    
    //设置窗口大小
    CGFloat scale = [[UIScreen mainScreen] scale];//获取视图放大倍数，可以把scale设置为1试试
    glViewport(self.frame.origin.x * scale, self.frame.origin.y * scale, self.frame.size.width * scale, self.frame.size.height * scale); //设置视口大小
    
   
    glUseProgram(_shaderProgram);
    
    // 主要设置颜色需要glUseProgram之后才有用
//    glUniform4f(_colorIndex, 0.0f, 0.0f, 1.0f, 1.0f);
    
    //获取shader里面的变量，这里记得要在glLinkProgram后面，后面，后面！
    GLuint rotate = glGetUniformLocation(_shaderProgram, "rotateMatrix");
    
    float radians = 60 * 3.14159f / 180.0f;
    float s = sin(radians);
    float c = cos(radians);
    
    //z轴旋转矩阵
//    GLfloat zRotation[16] = { //
//        c, -s, 0, 0.2, //
//        s, c, 0, 0,//
//        0, 0, 1.0, 0,//
//        0.0, 0, 0, 1.0//
//    };
    
    // 轴旋转矩阵
    GLfloat zRotation[16] = { //
        1, -s, c, 0.2, //
        0, c, s, 0,//
        0, 0, 0.0, 0,//
        0.0, 0, 0, 1.0//
    };

    
    //设置旋转矩阵
    glUniformMatrix4fv(rotate, 1, GL_FALSE, (GLfloat *)&zRotation[0]);
    
    
    glDrawArrays(GL_TRIANGLE_FAN, 0, 4);
    
    
    //渲染
    BOOL success =  [_context presentRenderbuffer:_colorRendrBuffer];
    if (!success) {
        
        NSLog(@"请求失败");
    }
}



#pragma mark - 加载纹理
- (GLuint)setupTexture:(NSString *)fileName {
    // 1获取图片的CGImageRef
    CGImageRef spriteImage = [UIImage imageNamed:fileName].CGImage;
    if (!spriteImage) {
        NSLog(@"Failed to load image %@", fileName);
        exit(1);
    }
    
    // 2 读取图片的大小
    size_t width = CGImageGetWidth(spriteImage);
    size_t height = CGImageGetHeight(spriteImage);
    
    GLubyte * spriteData = (GLubyte *) calloc(width * height * 4, sizeof(GLubyte)); //rgba共4个byte
    
    CGContextRef spriteContext = CGBitmapContextCreate(spriteData, width, height, 8, width*4,
                                                       CGImageGetColorSpace(spriteImage), kCGImageAlphaPremultipliedLast);
    
    // 3在CGContextRef上绘图
    CGContextDrawImage(spriteContext, CGRectMake(0, 0, width, height), spriteImage);
    
    CGContextRelease(spriteContext);
    
    // 4绑定纹理到默认的纹理ID（这里只有一张图片，故而相当于默认于片元着色器里面的colorMap，如果有多张图不可以这么做）
    glBindTexture(GL_TEXTURE_2D, 0);
    
    
    glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR );
    glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR );
    glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    
    float fw = width, fh = height;
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, fw, fh, 0, GL_RGBA, GL_UNSIGNED_BYTE, spriteData);
    
//    glBindTexture(GL_TEXTURE_2D, 0);
    
    free(spriteData);
    return 0;
}

@end
