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
uniform sampler2D texB;
uniform vec2 uniTexel;
uniform vec2 uniSize;
uniform float uniScale;


#endregion
// 
//==========================================================
//
#region MAIN FUNCTION.


void main() 
{
	// Operands, holds quad four corner coordinates. 
	vec2 lhs[4], rhs[4];
	vec2 lhsMid, rhsMid;
	
	// Use rate of change to all corner positions in any fragment.
	vec2 dx = dFdx(vPosition);
	vec2 dy = dFdy(vPosition);
	lhs[0] = vPosition - dx * gl_FragCoord.x - dy * gl_FragCoord.y;
	lhs[1] = lhs[0] + dx * uniSize.x;
	lhs[2] = lhs[0] + dy * uniSize.y;
	lhs[3] = lhs[1] + dy * uniSize.y;
	lhsMid = (lhs[0] + lhs[1] + lhs[2] + lhs[3]) * 0.25;
	
	// Rescale for user preference.
	lhs[0] = mix(lhsMid, lhs[0], uniScale);
	lhs[1] = mix(lhsMid, lhs[1], uniScale);
	lhs[2] = mix(lhsMid, lhs[2], uniScale);
	lhs[3] = mix(lhsMid, lhs[3], uniScale);
	
	// Get the other corners for collider area.
	// - texture A: [0: xy], [1: zw]
	// - texture B: [2: xy], [3: zw]
	vec2 coord = gl_FragCoord.xy * uniTexel;
	vec4 A = texture2D(texA, coord);
	vec4 B = texture2D(texB, coord);
	rhs[0] = A.xy;	
	rhs[1] = A.zw;
	rhs[2] = B.xy;	
	rhs[3] = B.zw;
	rhsMid = (rhs[0] + rhs[1] + rhs[2] + rhs[3]) * 0.25;
	
	// Check for AABB first. If no AABB collision, can't have OBB either.
	// As quads might be rotated, min-max must be separately be searchec.
	vec2 lhsMinMax[2];
	lhsMinMax[0] = min(min(lhs[0], lhs[1]), min(lhs[2], lhs[3])); 
	lhsMinMax[1] = max(max(lhs[0], lhs[1]), max(lhs[2], lhs[3]));
	
	vec2 rhsMinMax[2];
	rhsMinMax[0] = min(min(rhs[0], rhs[1]), min(rhs[2], rhs[3])); 
	rhsMinMax[1] = max(max(rhs[0], rhs[1]), max(rhs[2], rhs[3]));

	bool collided = (
		(lhsMinMax[0].x <= rhsMinMax[1].x) && 
		(lhsMinMax[1].x >= rhsMinMax[0].x) && 
		(lhsMinMax[0].y <= rhsMinMax[1].y) && 
		(lhsMinMax[1].y >= rhsMinMax[0].y)
	);
	
	if (!collided) 
	{
		gl_FragColor = vec4(0.0, 0.0, 0.0, 1.0);
		return;
	}
	
	// Proceed to do the OBB collision. Get the axes.
	vec2 axes[8];
	vec2 flip = vec2(1.0, -1.0);
	axes[0] = normalize((lhs[0] - lhs[1]) * flip).yx;
	axes[1] = normalize((lhs[1] - lhs[3]) * flip).yx;
	axes[2] = normalize((lhs[3] - lhs[2]) * flip).yx;
	axes[3] = normalize((lhs[2] - lhs[0]) * flip).yx;
	axes[4] = normalize((rhs[0] - rhs[1]) * flip).yx;
	axes[5] = normalize((rhs[1] - rhs[3]) * flip).yx;
	axes[6] = normalize((rhs[3] - rhs[2]) * flip).yx;
	axes[7] = normalize((rhs[2] - rhs[0]) * flip).yx;
	
	// Test each axis for separation.
	// Find alo Minimal Translation Vector
	vec3 mtv = vec3(0.0, 0.0, 65535.0); // vec2 + dist.
	for(int i = 0; i < 8; i++)
	{
		// Get projections smallest and largest values.
		vec2 axis = axes[i];
		vec2 lhsProj = vec2(dot(axis, lhs[0]));
		vec2 rhsProj = vec2(dot(axis, rhs[0]));
		for(int j = 1; j < 4; j++)
		{
			float lhsDot = dot(axis, lhs[j]);
			lhsProj[0] = min(lhsProj[0], lhsDot);
			lhsProj[1] = max(lhsProj[1], lhsDot);
			
			float rhsDot = dot(axis, rhs[j]);
			rhsProj[0] = min(rhsProj[0], rhsDot);
			rhsProj[1] = max(rhsProj[1], rhsDot);
		}
		
		// If there is separation, then there is no collision.
		float overlap = max(0.0, min(lhsProj[1], rhsProj[1]) - max(lhsProj[0], rhsProj[0]));
		if (overlap <= 0.0)
		{
			gl_FragColor = vec4(0.0, 0.0, 0.0, 1.0);
			return;
		}
		
		// Get minimal translation vector.
		if (overlap < mtv.z)
		{
			float dir = (dot(lhsMid, axis) < dot(rhsMid, axis)) ? 1.0 : -1.0;
			mtv.xy = axis * dir;
			mtv.z = overlap;
		}
	}
	
	// No separating axis found, therefore there is collision.
	vec2 translate = mtv.xy * mtv.z;
	gl_FragColor = vec4(1.0, translate, 1.0);
	return;
}


#endregion
// 
//==========================================================

