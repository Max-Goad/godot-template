# Note: Replace UID when copying from template
@icon("uid://ddjw4kyq1rqmn")
class_name NavDestination extends Area2D

#region Variables
@export var selectable: bool = true: set = _set_selectable
@export var collision: CollisionShape2D
@export var triggers: Triggers

signal selected(dest)

func reach():
	triggers.execute()

func _input_event(_viewport: Viewport, event: InputEvent, _shape_idx: int) -> void:
	if (event is InputEventMouseButton
	and event.button_index in [MOUSE_BUTTON_LEFT, MOUSE_BUTTON_RIGHT]
	and event.is_released()
	and selectable):
		selected.emit(self)

func _set_selectable(value: bool):
	selectable = value
	# setters can get called before the object has entered the tree, therefore its
	# child objects haven't been initialized yet and we need this check
	if is_inside_tree():
		collision.disabled = not value
