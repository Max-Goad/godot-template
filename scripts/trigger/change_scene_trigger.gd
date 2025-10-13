class_name ChangeSceneTrigger extends Trigger

@export var action = GlobalScene.Action.PUSH
@export var scene: PackedScene

func execute():
	match action:
		GlobalScene.Action.PUSH:
			GlobalScene.push_scene(scene.resource_path)
		GlobalScene.Action.POP:
			GlobalScene.pop_scene()
		GlobalScene.Action.CHANGE:
			GlobalScene.change_scene(scene.resource_path)
