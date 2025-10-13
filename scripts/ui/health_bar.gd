extends ProgressBar

### Variables
@export var color_steps: Array[ColorStep]
var fill : StyleBoxFlat

### Public Functions
func change_value(v: int) -> void:
	self.value += v

### Engine Functions
func _ready():
	_validate_color_steps()
	self.fill = self.get_theme_stylebox("fill").duplicate()
	self.add_theme_stylebox_override("fill", self.fill)

	self.value_changed.connect(_on_value_changed)
	_on_value_changed(self.value)

### Private Functions
func _on_value_changed(v):
	for cs in self.color_steps:
		if v <= cs.max_value:
			self.fill.bg_color = cs.color
			self.fill.border_color = cs.color.darkened(0.25)
			break

	if v == max_value:
		self.fill.set_corner_radius_all(0)
	else:
		self.fill.corner_radius_top_right = 5
		self.fill.corner_radius_bottom_right = 5

func _validate_color_steps():
	var current_max = 0
	for cs in self.color_steps:
		assert(cs.max_value > current_max, "invalid color steps")
		current_max = cs.max_value
