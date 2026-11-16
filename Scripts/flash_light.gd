extends SpotLight3D

signal toggle(is_on)

func _unhandled_input(event):
	if event.is_action_pressed("flashlight"):
		visible = not visible
		toggle.emit(visible)
