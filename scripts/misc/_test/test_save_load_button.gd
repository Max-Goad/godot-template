extends Button

enum Mode {
	SAVE,
	LOAD,
	ERASE
}

@export var textbox: TextEdit
@export var label: Label
@export var slot: int = 0
@export var mode: Mode = Mode.SAVE

func _ready():
	if GlobalData.saves[slot] != null:
		label.text = "YES"
	else:
		label.text =  "NO"

func _pressed() -> void:
	match mode:
		Mode.SAVE:
			if textbox.text:
				GlobalData.test_string = textbox.text
				GlobalData.save_file(slot, "Test")
				textbox.text = ""
		Mode.LOAD:
			textbox.text = ""
			if GlobalData.save_exists(slot):
				GlobalData.load_file(slot)
				textbox.text = GlobalData.test_string
		Mode.ERASE:
			textbox.text = ""
			GlobalData.erase_file(slot)
	if GlobalData.saves[slot] != null:
		label.text = "YES"
	else:
		label.text =  "NO"
