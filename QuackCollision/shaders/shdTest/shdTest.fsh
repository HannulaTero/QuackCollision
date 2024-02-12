varying vec2 v_vTexcoord;
varying vec3 vA;
varying vec2 vB;
varying vec2 vPos;

uniform vec2 uniSize;

void main()
{
	vec2 dx = vec2(dFdx(vPos.x), dFdy(vPos.y)); 
	vec2 lhs = vPos - dx * gl_FragCoord.xy;
	vec2 rhs = lhs + dx * uniSize;
	vec2 posMin = min(lhs, rhs);
	vec2 posMax = max(lhs, rhs);
	
    gl_FragData[0] = vec4(v_vTexcoord, 0.0, 1.0);
    gl_FragData[1] = vec4(vA, 1.0);
    gl_FragData[2] = vec4(vB, 0.0, 1.0);
    gl_FragData[3] = vec4(posMin, posMax);
}
