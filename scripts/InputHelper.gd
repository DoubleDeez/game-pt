extends Node

func IsInputEventPressed(event, name, allowRepeat):
	return event.is_action_pressed(name) && (!event.is_echo() || allowRepeat)
