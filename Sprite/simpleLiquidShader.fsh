void main() {
    float speed = u_time * 0.35;
    float frequency = 14.0;
    float intensity = 0.006;
    vec2 coord = v_tex_coord;
    coord.x += cos((coord.x + speed) * frequency) * intensity;
    coord.y += sin((coord.y + speed) * frequency) * intensity;
    vec4 targetPixelColor = texture2D(u_texture, coord);
    gl_FragColor = targetPixelColor;
}
