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
	vec2 lhsMid, rhsMid;
	
	// Get drawn quad.
	// Use rate of change to all corner positions in any fragment.
	vec2 dx = dFdx(vPosition);
	vec2 dy = dFdy(vPosition);
	lhs[0] = vPosition - dx * gl_FragCoord.x - dy * gl_FragCoord.y;
	lhs[1] = lhs[0] + dx * uniSize.x + dy * uniSize.y;
	
	// Rescale for user preference.
	lhsMid = (lhs[0] + lhs[1]) * 0.5;
	lhs[0] = mix(lhsMid, lhs[0], uniScale);
	lhs[1] = mix(lhsMid, lhs[1], uniScale);
	
	// Get given collider area.
	// - texture A: [min: xy], [max: zw]
	vec2 coords = gl_FragCoord.xy * uniTexel;
	vec4 A = texture2D(texA, coords);
	rhs[0] = A.xy;
	rhs[1] = A.zw;
	rhsMid = (rhs[0] + rhs[1]) * 0.5;
	
	// Get Quads Min-Maxes for the AABB collision.
	vec2 lhsMinMax[2];
	lhsMinMax[0] = min(lhs[0], lhs[1]); 
	lhsMinMax[1] = max(lhs[0], lhs[1]);
	
	vec2 rhsMinMax[2];
	rhsMinMax[0] = min(rhs[0], rhs[1]);
	rhsMinMax[1] = max(rhs[0], rhs[1]);

	// Check for AABB collision.
	bool collision = (
		(lhsMinMax[0].x <= rhsMinMax[1].x) && 
		(lhsMinMax[1].x >= rhsMinMax[0].x) &&
		(lhsMinMax[0].y <= rhsMinMax[1].y) && 
		(lhsMinMax[1].y >= rhsMinMax[0].y)
	);
	
	// No collision as didn't overlap in both directions.
	// Quit early, as no need to calculate MTV.
	if (!collision)
	{
		gl_FragColor = vec4(0.0, 0.0, 0.0, 1.0);
		return;
	}
	
	// There is collision, calculate overlap.
	vec2 overlap = vec2(0.0);
	overlap.x = (lhsMid.x <= rhsMid.x)
		? (lhsMinMax[1].x - rhsMinMax[0].x)
		: (lhsMinMax[0].x - rhsMinMax[1].x);
	overlap.y = (lhsMid.y <= rhsMid.y)
		? (lhsMinMax[1].y - rhsMinMax[0].y)
		: (lhsMinMax[0].y - rhsMinMax[1].y);
		
	// Get Minimal Translation Vector.
	vec2 mtv = (abs(overlap.x) <= abs(overlap.y))
		? vec2(overlap.x, 0.0)
		: vec2(0.0, overlap.y);
	
	// Store the results.
	gl_FragColor = vec4(1.0, mtv, 1.0);
}


#endregion
// 
//==========================================================

