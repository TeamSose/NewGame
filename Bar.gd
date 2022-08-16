extends TextureProgress

export var power = false

func _on_Bar_value_changed(value):
	if value == 100:
		power = true
	else:
		power = false
