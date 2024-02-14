// Varying & uniforms.
varying vec2 vPosition;
uniform vec2 uniPosition;
uniform float uniDistance;

// Main function.
void main() 
{
	// Calculate whether positions are close enough.
	float dist = distance(vPosition, uniPosition);
	float collided = float(dist <= uniDistance);
		
	// Store results as 1/255th, as normalized 8bit value.
	// When blend is cumulative, then we can count collisions up to 255.
	gl_FragColor = vec4(collided, 0.0, 0.0, 1.0) / 255.0;
}



