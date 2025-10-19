# Note: Replace UID when copying from template
@icon("uid://bebqib84wg1hi")
@tool
class_name NavMap extends Node2D

enum DisplayMode { Always, EditorOnly, Never }

@export var connections: Array[NavConnection] : set = _set_connections
var destinations: Array[NavDestination]
var dest_to_index: Dictionary[Node, int]
var astar: AStar2D

@export_group("Display")
@export var draw_connections := DisplayMode.EditorOnly : set = _set_draw_connections
@export var connection_color := Color.WHITE : set = _set_connection_color
@export var connection_disabled_color := Color.LIGHT_CORAL : set = _set_connection_disabled_color
@export_range(0.0, 10.0, 0.1) var connection_width := 5.0 : set = _set_connection_width

func _ready() -> void:
	if Engine.is_editor_hint():
		return
	destinations = _populate_destinations_from_connections()
	_assign_index_to_destinations()
	astar = _generate_astar()

func _draw() -> void:
	match draw_connections:
		DisplayMode.Always:
			_draw_connections()
		DisplayMode.EditorOnly:
			if Engine.is_editor_hint():
				_draw_connections()

# Note: Returns [dest] if we're already at the destination
#		Returns null if there's no path to the destination
func generate_path(from: Vector2, to: NavDestination) -> Array[NavDestination]:
	var dest = _point_is_on_destination(from)
	if dest:
		return generate_path_between(dest, to)

	var conn = _point_is_on_connection(from)
	if conn:
		if conn.bidirectional:
			var indexes = _shortest_path([get_node(conn.a), get_node(conn.b)], to)
			return _indexes_to_destinations(indexes)
		else:
			var indexes = astar.get_id_path(dest_to_index[get_node(conn.b)], dest_to_index[to])
			return _indexes_to_destinations(indexes)
	# We're off the navigation tree, so build a path starting from the closest node
	else:
		var indexes = astar.get_id_path(dest_to_index[closest_to(from)], dest_to_index[to])
		return _indexes_to_destinations(indexes)

func generate_path_between(from: NavDestination, to: NavDestination):
	if from == to:
		return [from]
	else:
		var indexes = astar.get_id_path(dest_to_index[from], dest_to_index[to])
		return _indexes_to_destinations(indexes)

func distance(a: NavDestination, b: NavDestination):
	var path = generate_path_between(a, b)
	# Path includes "a", so we must subtract 1
	return path.size() - 1

func destinations_at_distance(from: NavDestination, target_distance: int) -> Array[NavDestination]:
	var candidates: Array[NavDestination] = []
	for dest in destinations:
		if dest == from:
			continue
		if distance(from, dest) == target_distance:
			candidates.push_back(dest)
	return candidates

func closest_to(pos: Vector2) -> NavDestination:
	return destinations[astar.get_closest_point(pos)]

func random() -> NavDestination:
	return destinations.pick_random()

func random_index() -> int:
	return get_index_from_dest(random())

func get_index_from_dest(dest: NavDestination) -> int:
	return dest_to_index[dest]

func get_dest_from_index(index: int) -> NavDestination:
	return destinations[index]

func add_connection(conn: NavConnection):
	connections.push_back(conn)

func remove_connection_between(a: NavDestination, b: NavDestination):
	for connection in connections:
		if a.get_path() == connection.a and b.get_path() == connection.b:
			connections.erase(connection)
			return

#region Private Functions
func _populate_destinations_from_connections() -> Array[NavDestination]:
	var out: Array[NavDestination] = []
	for connection in connections:
		var a: NavDestination = get_node(connection.a)
		var b: NavDestination = get_node(connection.b)
		if a not in out:
			out.push_back(a)
		if b not in out:
			out.push_back(b)
	return out

func _assign_index_to_destinations():
	for i in destinations.size():
		destinations[i].index = i

func _generate_astar() -> AStar2D:
	var out := AStar2D.new()
	dest_to_index.clear()
	# Generate Points
	for i in destinations.size():
		var dest = destinations[i]
		out.add_point(i, dest.position)
		dest_to_index[dest] = i
	# Generate Segments
	for connection in connections:
		var a: NavDestination = get_node(connection.a)
		var b: NavDestination = get_node(connection.b)
		out.connect_points(dest_to_index[a], dest_to_index[b], connection.bidirectional)
	return out

func _point_is_on_line(point: Vector2, l1: Vector2, l2: Vector2) -> bool:
	# A point is aligned with a line if the vector(l1 -> l2)
	# is parallel with the vector(point -> l2).
	var line = (l2 - l1).normalized()
	var comparison = (l2 - point).normalized()
	var aligned = snapped(comparison.cross(line), 0.001) == 0
	# Alignment isn't good enough, we need to make sure the point
	# actually is within the x/y range of l1 -> l2
	var xmin = min(l1.x, l2.x)
	var xmax = max(l1.x, l2.x)
	var ymin = min(l1.y, l2.y)
	var ymax = max(l1.y, l2.y)
	var within_range = (point.x >= xmin and point.x <= xmax
					and point.y >= ymin and point.y <= ymax)
	return aligned and within_range

func _point_is_on_connection(point: Vector2) -> NavConnection:
	for connection in connections:
		var a: NavDestination = get_node(connection.a)
		var b: NavDestination = get_node(connection.b)
		if _point_is_on_line(point, a.position, b.position):
			return connection
	return null

func _point_is_on_destination(point: Vector2) -> NavDestination:
	for dest in destinations:
		if point == dest.position:
			return dest
	return null

func _shortest_path(from_candidates: Array[NavDestination], to: NavDestination) -> PackedInt64Array:
	var shortest: PackedInt64Array = []
	for from in from_candidates:
		var p = astar.get_id_path(dest_to_index[from], dest_to_index[to])
		if not shortest or p.size() < shortest.size():
			shortest = p
	return shortest

func _indexes_to_destinations(indexes: PackedInt64Array) -> Array[NavDestination]:
	var out: Array[NavDestination] = []
	for i in indexes:
		out.push_back(destinations[i])
	return out
#endregion

#region Setters
func _set_connections(value):
	connections = value
	queue_redraw()

func _set_draw_connections(value):
	draw_connections = value
	queue_redraw()

func _set_connection_color(value):
	connection_color = value
	queue_redraw()

func _set_connection_disabled_color(value):
	connection_disabled_color = value
	queue_redraw()

func _set_connection_width(value):
	connection_width = value
	queue_redraw()
#endregion

func _draw_connections():
	for connection in connections:
		if connection == null or not has_node(connection.a) or not has_node(connection.b):
			continue
		var anode = get_node(connection.a)
		var bnode = get_node(connection.b)
		var a: Vector2 = anode.position
		var b: Vector2 = bnode.position
		if connection.bidirectional:
			draw_line(a, b, connection_color, connection_width)
		else:
			var h := a.lerp(b, 0.5)
			var ah := h.lerp(b, 0.025 * connection_width)
			var at := h.lerp(a, 0.025 * connection_width)
			draw_line(a, ah, connection_color, connection_width)
			draw_line(ah, b, connection_disabled_color, connection_width)
			draw_line(ah, (at-ah).rotated(PI/4.0)+ah, connection_color, connection_width)
			draw_line(ah, (at-ah).rotated(-PI/4.0)+ah, connection_color, connection_width)
			# Draw the rest of the arrowhead in
			draw_line(ah, (at-ah).rotated(3.0*PI/4.0)/7.5+ah, connection_color, connection_width)
