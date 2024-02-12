attribute vec3 in_Position;
attribute vec4 in_Colour;
attribute vec2 in_TextureCoord;

varying vec2 vPosition;

uniform int uniUseCorner;
uniform vec2 uniCoordMiddle;

void main()
{
	// Find out vertex corner information.
	// CornerId doesn't work with physics particles.
	vec2 vertexOffset;
	if (uniUseCorner == 0)
	{
		bvec2 larger = greaterThan(in_TextureCoord, uniCoordMiddle);
		vertexOffset = vec2(larger) * 2.0 - 1.0;
	}
	else
	{
		vec2 bits = mod(in_Colour.rb * 255.0, 2.0);
		int cornerId = int(dot(vec2(1.0, 2.0), bits));
			 if (cornerId == 0) vertexOffset = vec2(-1.0, -1.0);
		else if (cornerId == 1) vertexOffset = vec2(+1.0, -1.0);
		else if (cornerId == 2) vertexOffset = vec2(+1.0, +1.0);
		else if (cornerId == 3) vertexOffset = vec2(-1.0, +1.0);
	} 

	
	// Move vertices to cover whole render area.
	gl_Position = vec4(vertexOffset, 0.5, 1.0);
	
	// World position of particle.
	vec4 worldPos = gm_Matrices[MATRIX_WORLD] * vec4(in_Position, 1.0);
	vPosition = worldPos.xy;
}
