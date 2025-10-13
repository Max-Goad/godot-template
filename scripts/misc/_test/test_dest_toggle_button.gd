extends Button

@export var destination: NavDestination

func _toggled(t: bool) -> void:
	destination.selectable = t
