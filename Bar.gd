extends TextureProgress

signal active(value)

func _on_Bar_value_changed(value):
	if value == 100:
		emit_signal("active", true)
	if value == 0:
		emit_signal("active", false)
