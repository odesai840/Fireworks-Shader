#define NUM_EXPLOSIONS 12.0
#define NUM_PARTICLES 75.0

vec2 Hash12(float t)
{
    float x = fract(sin(t*654.3)*452.6);
    float y = fract(sin((t+x)*712.3)*253.2);
    
    return vec2(x,y);
}

vec2 Hash12_Polar(float t)
{
    float a = fract(sin(t*654.3)*452.6)*6.2832;
    float d = fract(sin((t+a)*712.3)*253.2);
    
    return vec2(sin(a),cos(a))*d;
}

float Explosion(vec2 uv, float t)
{
    float sparks = 0.0;
    
    for(float i=1.0; i<NUM_PARTICLES; i++)
    {
        vec2 dir = Hash12_Polar(i)*0.5;
        float d = length(uv-dir*t);
        float brightness = mix(0.0005,0.0002,smoothstep(0.01,0.0,t));
        
        brightness *= sin(t*20.0+i)*0.5+0.5;
        brightness *= smoothstep(1.0,0.75,t);
        sparks += brightness/d;
    }
    
    return sparks;
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    // Normalized pixel coordinates (from 0 to 1)
    vec2 uv = (fragCoord-0.5*iResolution.xy)/iResolution.y;
    
    vec3 col = vec3(0.0);
    
    for(float i=1.0; i<NUM_EXPLOSIONS; i++){
        float t = iTime+i/NUM_EXPLOSIONS;
        float ft = floor(i);
        vec3 color = sin(2.0*vec3(.22,.45,.56)*ft)*0.25+0.75;
        vec2 offs = Hash12(i+1.0+ft*NUM_EXPLOSIONS)-0.5;
        
        offs *= vec2(1.77,1.0);
        
        col += Explosion(uv-offs,fract(t))*color;
    }

    // Output to screen
    fragColor = vec4(col,1.0);
}