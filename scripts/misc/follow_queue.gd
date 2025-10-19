class_name FollowQueue extends Node2D
## A node used to make other nodes track and follow its position.
##
## This node's followers will follow the node at a certain distance, and multiple
## followers will queue up behind one another such that a follow queue is formed.
## [br]
## [color=yellow]Warning:[/color] This can be performance and/or memory intensive.
## Please see [member poll_interval] for ways to increase performance.

#region Variables
## The distance each follower will keep with each other.
## [color=yellow]Warning:[/color] Setting this value too high will cost a lot of memory!
@export_range(0, 50) var distance := 10
## The interval at which the followers will be updated to the FollowQueue's position.
## A low interval means high accuracy but potentially high performance costs.
## A high interval means less accuracy but better performance.
@export_range(1, 10, 1) var poll_interval := 1
## The list of nodes that will follow the FollowQueue node.
## The nodes will follow in order of this array.
@export var followers: Array[Node2D]
## Internal variable tracking the position of this node to be replicated to followers.
var _buffer: Array[Vector2]
## Internal variable tracking polling
var _current_polling_interval := 0

func _ready() -> void:
	# Seed the buffer with our current position
	_buffer.push_back(global_position)

func _process(_d: float) -> void:
	# Check the polling interval to see if we should update
	_current_polling_interval = (_current_polling_interval+1) % poll_interval
	if _current_polling_interval != 0:
		return
	# Ensure buffer is always large enough to handle all items
	while _buffer.size() <= followers.size() * distance:
		_buffer.push_back(_buffer.back())
	# Skip the processing if there's no position change
	if _buffer.front() == global_position:
		return
	# Update followers (at appropriate distances)
	for i in followers.size():
		var follower = followers[i]
		follower.global_position = _buffer[(i+1)*distance]
	# Update buffer
	_buffer.push_front(global_position)
	_buffer.pop_back()
