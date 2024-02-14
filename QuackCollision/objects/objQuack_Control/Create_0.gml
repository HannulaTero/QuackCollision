/// @desc INITIALIZE

// Collision information.
collisions = 0;
moveX = 0;
moveY = 0;
total = 0;

// Enable text effects.
font_enable_effects(ftQuack_Example, true, {
    outlineEnable: true,
    outlineDistance: 2,
    outlineColour: c_black,
	dropShadowEnable: true,
    dropShadowSoftness: 32,
    dropShadowOffsetX: 0,
    dropShadowOffsetY: 2,
    dropShadowColour: c_black,
    dropShadowAlpha: 1.0,
});