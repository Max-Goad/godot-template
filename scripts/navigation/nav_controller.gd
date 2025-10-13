# Note: Replace UID when copying from template
@icon("uid://camublqvyn4ls")
class_name NavController extends Node2D

@export var disabled: bool = false
@export var map: NavMap
@export var pawn: NavPawn

func destination_selected(dest: NavDestination):
	if not disabled:
		pawn_initiate_move(dest)

func pawn_initiate_move(dest: NavDestination):
	if not disabled:
		var path_to_dest = map.generate_path(pawn.position, dest)
		pawn.initiate_move(path_to_dest)

func pawn_reached_destination(dest: NavDestination):
	if not disabled:
		dest.reach()
