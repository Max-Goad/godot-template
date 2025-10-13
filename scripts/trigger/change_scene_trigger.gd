class_name ChangeSceneTrigger extends Trigger

@export var action = GlobalScene.Action.PUSH
@export var scene: PackedScene

@warning_ignore("shadowed_variable")
static func new_node(action: GlobalScene.Action, scene: PackedScene) -> ChangeSceneTrigger:
	var node = Node.new()
	node.set_script(Trigger.Basic.change_scene)
	var change_scene_trigger = node as ChangeSceneTrigger
	change_scene_trigger.action = action
	change_scene_trigger.scene = scene
	return change_scene_trigger

func execute():
	match action:
		GlobalScene.Action.PUSH:
			GlobalScene.push_scene(scene.resource_path)
		GlobalScene.Action.POP:
			GlobalScene.pop_scene()
		GlobalScene.Action.CHANGE:
			GlobalScene.change_scene(scene.resource_path)

