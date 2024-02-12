//==========================================================
//
#region DECLARE: VARYING.


varying vec2 vPosition;


#endregion
// 
//==========================================================
//
#region DECLARE: UNIFORMS.


uniform sampler2D texA;
uniform vec2 uniTexel;
uniform vec2 uniSize;
uniform vec2 uniScale;


#endregion
// 
//==========================================================
//
#region MAIN FUNCTION.


void main() 
{
	// Operands, holds quad min-max coordinates.
	// Assumption, that these are non-rotated rectangular quads.
	vec2 lhs[2], rhs[2];
	
	// Get drawn quad.
	// Use rate of change to all corner positions in any fragment.
	vec2 dx = dFdx(vPosition);
	vec2 dy = dFdy(vPosition);
	lhs[0] = vPosition - dx * gl_FragCoord.x - dy * gl_FragCoord.y;
	lhs[1] = lhs[0] + dx * uniSize.x + dy * uniSize.y;
	
	// Rescale for user preference.
	vec2 mid = (lhs[0] + lhs[1]) * 0.5;
	lhs[0] = mix(mid, lhs[0], uniScale);
	lhs[1] = mix(mid, lhs[1], uniScale);
	
	// Get given collider area.
	// - texture A: [min: xy], [max: zw]
	vec2 coords = gl_FragCoord.xy * uniTexel;
	vec4 A = texture2D(texA, coords);
	rhs[0] = A.xy;
	rhs[1] = A.zw;
	
	// Check for the collision.
	bool collided = (
		(lhs[0].x <= rhs[1].x) && 
		(lhs[1].x >= rhs[0].x) && 
		(lhs[0].y <= rhs[1].y) && 
		(lhs[1].y >= rhs[0].y)
	);
	
	// Store the results.
	gl_FragColor = vec4(collided, 0.0, 0.0, 1.0);
}


#endregion
// 
//==========================================================

