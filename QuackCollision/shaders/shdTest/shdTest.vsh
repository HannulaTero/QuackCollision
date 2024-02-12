
attribute vec3 in_Position;
attribute vec4 in_Colour;
attribute vec2 in_TextureCoord;

varying vec2 v_vTexcoord;
varying vec3 vA;
varying vec2 vB;
varying vec2 vPos;

void main()
{
	// Find out vertex corner information.
	vec2 bits = mod(in_Colour.rb * 255.0, 2.0);
	int cornerId = int(dot(vec2(1.0, 2.0), bits));
	vec2 vertexOffsetA;
		 if (cornerId == 0) vertexOffsetA = vec2(-1.0, -1.0);
	else if (cornerId == 1) vertexOffsetA = vec2(+1.0, -1.0);
	else if (cornerId == 2) vertexOffsetA = vec2(+1.0, +1.0);
	else if (cornerId == 3) vertexOffsetA = vec2(-1.0, +1.0);
	
	// Or replace with this, if sprite is own texture page:
	vec2 vertexOffsetB = floor(in_TextureCoord + 0.5) * 2.0 - 1.0;
	
    vec4 position = vec4(in_Position, 1.0);

    v_vTexcoord = in_TextureCoord;
	vA = vec3(vertexOffsetA, cornerId);
	vB = vertexOffsetB;
	vPos = position.xy;
	
	//gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * vec4(in_Position, 1.0);
	gl_Position = vec4(vertexOffsetA, 0.5, 1.0);
}
