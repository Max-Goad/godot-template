class_name Triggers extends Trigger

@export var pause_during_execution: bool = false

func _ready() -> void:
	self.process_mode = PROCESS_MODE_ALWAYS

func execute():
	var tree = get_tree()
	if pause_during_execution:
		tree.paused = true
	for trigger in get_children():
		assert(trigger is Trigger, "Non-Trigger child found under triggers")
		print("Triggers: execute trigger %s" % trigger.name)
		await trigger.execute()
	if pause_during_execution:
		# If a trigger caused the tree to be refreshed/freed, then skip the unpause
		if tree:
			tree.paused = false
