/// @desc EDIT TEXT

if (keyboard_string != "")
{
	text += keyboard_string;
	keyboard_string = "";
}

if (keyboard_check_pressed(vk_backspace))
{
	text = string_delete(text, string_length(text), 1);
}


if (keyboard_check_pressed(vk_enter))
{
	text += "\n";
}
