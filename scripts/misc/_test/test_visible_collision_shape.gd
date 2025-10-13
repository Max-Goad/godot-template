extends Button

@export var visible_collision_shape_2d: VisibleCollisionShape2D

func _ready() -> void:
	assert(visible_collision_shape_2d, "unassigned variable")

func _pressed() -> void:
	visible_collision_shape_2d.disabled = !visible_collision_shape_2d.disabled
