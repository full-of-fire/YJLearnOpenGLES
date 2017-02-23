//定点着色器
attribute vec4 position; // 属性，位置
uniform vec4 color; // 颜色值
varying lowp vec4 colorVarying; // 这个值传给片段着色器用

void main() {

    gl_Position = position;
    colorVarying = color;
}
