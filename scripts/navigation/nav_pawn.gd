# Note: Replace UID when copying from template
@icon("uid://caotv31fjq3l3")
class_name NavPawn extends Sprite2D

#region Variables
@export_range(0.5, 4.0) var move_speed : float = 1.0

var path: Path2D
var follow: PathFollow2D
var moving : bool
var direction: Vector2
var destination: NavDestination
#endregion

#region Signals
signal reached_destination
#endregion

#region Engine Functions
func _ready():
	_instantiate_path()
	_reset()

func _process(delta):
	if moving:
		if follow.progress_ratio >= 1.0 or self.position == destination.position:
			_reach_destination()
		else:
			follow.progress += move_speed * 250 * delta
			position = follow.position
			direction = _determine_direction()
#endregion

#region Public Functions
func at_destination(d: NavDestination) -> bool:
	return not moving and self.position == d.position

func initiate_move(p: Array[NavDestination]):
	# If we have no path it means the destination is unreachable.
	# Do nothing.
	if not p:
		return

	# Create curve from path
	path.curve.clear_points()
	# If we're not at a destination, add our current position at the start
	if position != p.front().position:
		path.curve.add_point(position)
	for d in p:
		path.curve.add_point(d.position)
	#
	follow.progress = 0
	destination = p.back()
	moving = true

func move_instantly(d: NavDestination):
	initiate_move([d])
	self.position = destination.position
#endregion

#region Private Functions
func _instantiate_path():
	self.path = Path2D.new()
	self.path.curve = Curve2D.new()
	add_child(self.path)
	self.follow = PathFollow2D.new()
	self.follow.loop = false
	self.path.add_child(self.follow)

func _reset():
	path.curve.clear_points()
	follow.progress = 0
	moving = false
	direction = Vector2.ZERO

func _determine_direction() -> Vector2:
	var original_progress = follow.progress
	var original_position = follow.position
	follow.progress += 5
	var predicted_position = follow.position
	follow.progress = original_progress
	return (predicted_position - original_position).normalized()

func _reach_destination():
	reached_destination.emit(self.destination)
	_reset()
#endregion
