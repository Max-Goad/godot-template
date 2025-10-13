@tool
class_name VisibleCollisionShape2D extends CollisionShape2D

@export var color: Color = Color(Color.AQUA, 0.3) : set = _set_color
@export var disabled_color: Color = Color(Color.LIGHT_CORAL, 0.3) : set = _set_disabled_color

@export_group("Border")
@export var border: bool = true : set = _set_border
@export var border_color: Color = Color.BLACK : set = _set_border_color
@export var border_size: float = 5.0 : set = _set_border_size


func _ready() -> void:
	assert(shape is CircleShape2D or shape is RectangleShape2D, "Cannot make VisibleCollisionShape2D with this shape type!")

func _draw() -> void:
	var final_color = color if not disabled else disabled_color
	if shape is CircleShape2D:
		var radius := (shape as CircleShape2D).radius
		draw_circle(Vector2.ZERO, radius, final_color)
		if border:
			draw_circle(Vector2.ZERO, radius, border_color, false, border_size)
	elif shape is RectangleShape2D:
		var size:Vector2 = shape.size
		var rect: = Rect2(-size.x * 0.5, -size.y * 0.5, size.x, size.y)
		draw_rect(rect, final_color)
		if border:
			draw_rect(rect, border_color, false, border_size)
	else:
		assert(false, "VisibleCollisionShape2D has not been implemented for this shape type")

func _set_color(value):
	color = value
	queue_redraw()

func _set_disabled_color(value):
	disabled_color = value
	queue_redraw()

func _set_border(value):
	border = value
	queue_redraw()

func _set_border_color(value):
	border_color = value
	queue_redraw()

func _set_border_size(value):
	border_size = value
	queue_redraw()
