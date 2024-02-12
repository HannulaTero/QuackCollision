// Varying.
varying vec2 vPosition;

// Uniforms.
uniform sampler2D texAreas;
uniform vec2 uniTexel;
uniform vec2 uniOutputSize;
uniform vec4 uniQuadScale;
uniform vec4 uniQuadOffset;

// Components.
#define XMIN 0
#define YMIN 1
#define XMAX 2
#define YMAX 3


// Collision function: Axis-Aligned Bounding Box.
float CollisionAABB(vec4 lhs, vec4 rhs)
{
	return float(
		(lhs[XMIN] <= rhs[XMAX]) && 
		(lhs[XMAX] >= rhs[XMIN]) && 
		(lhs[YMIN] <= rhs[YMAX]) && 
		(lhs[YMAX] >= rhs[YMIN])
	);
}

// Collision function: Oriented Bounding Box.
float CollisionOBB(vec4 lhs, vec4 rhs)
{
	return 0.0;
}


// Main function.
void main() 
{
	// Get rate of change to find position.
	// This way positions for quad corners can be found in any fragment.
	vec2 derivative;
	derivative.x = dFdx(vPosition.x);
	derivative.y = dFdy(vPosition.y);
	vec2 posL = vPosition - derivative * gl_FragCoord.xy;
	vec2 posR = posL + derivative * uniOutputSize;

	// Get quad axis-aligned bounding box.
	// Min-Max coordinates.
	vec2 posMin = min(posL, posR);
	vec2 posMax = max(posL, posR);
	vec2 posMid = (posL + posR) * 0.5;
	vec4 quad = mix(posMid.xyxy, vec4(posMin, posMax), uniQuadScale);
	quad += uniQuadOffset;
	
	// Get collider area axis-aligned bounding box.
	vec2 coord = gl_FragCoord.xy * uniTexel;
	vec4 area = texture2D(texAreas, coord);
	
	// Calculate AABB collision.
	float collideAABB = CollisionAABB(area, quad);
	
	// Store result.
	gl_FragColor = vec4(collideAABB, 0.0, 0.0, 1.0);
}



