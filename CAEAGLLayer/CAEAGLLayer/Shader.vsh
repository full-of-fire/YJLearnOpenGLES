
//定点着色器
attribute vec4 position; // 属性，位置
attribute vec2 textureCoordinate; //纹理坐标

uniform mat4 rotateMatrix;
varying lowp vec2 varyTexture;

void main() {
    
    gl_Position = position * rotateMatrix;
    varyTexture = textureCoordinate;
}
