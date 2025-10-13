class_name Textbox extends Control

### Variables
@onready var label: Label = $PanelContainer/MarginContainer/Label
@onready var timer: Timer= $Timer

@export_multiline var text: String
@export var cancellable: bool = true
@export var finished: bool = false

@export var timeout_override: float

### Signals
signal complete

### Public Functions
func start():
	timer.start()

### Engine Functions
func _ready():
	if text:
		label.text = text
	timer.one_shot = true
	timer.timeout.connect(_finish)
	if timeout_override:
		timer.wait_time = timeout_override

func _gui_input(event: InputEvent) -> void:
	if cancellable and event is InputEventMouseButton and event.button_index in [MOUSE_BUTTON_LEFT, MOUSE_BUTTON_RIGHT] and event.is_released():
		print("Textbox Cancelled")
		_finish()

### Private Functions
func _finish():
	if not finished:
		finished = true
		complete.emit()
		# TODO: Is this the best place to do this? Or should a queue handle this instead?
		queue_free()
