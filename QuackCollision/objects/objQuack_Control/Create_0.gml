/// @desc INITIALIZE

infoDraw = true;
debugDraw = false;

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