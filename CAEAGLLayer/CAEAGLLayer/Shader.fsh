
uniform sampler2D colorMap;
varying lowp vec2 varyTexture;
void main() {
    
    gl_FragColor = texture2D(colorMap,varyTexture);
}
