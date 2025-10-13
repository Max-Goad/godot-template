class_name TextboxTrigger extends Trigger

@export_multiline var text: String = ""
@export_range(1.0, 10.0) var timeout: float = 5.0

const textbox_scene = preload("res://resources/ui/textbox.tscn")

func execute():
	var textbox: Textbox = textbox_scene.instantiate()
	textbox.text = text
	textbox.timeout_override = timeout
	get_tree().current_scene.add_child(textbox)
	textbox.start()
	await textbox.complete
