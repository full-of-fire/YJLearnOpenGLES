//
//  YJShaderManager.h
//  CAEAGLLayer
//
//  Created by yj on 17/2/23.
//  Copyright © 2017年 yj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenGLES/ES2/gl.h>
@interface YJShaderManager : NSObject

- (GLuint)shaderProgam;
// 使用着色器程序
- (BOOL)useProgram;
@end
