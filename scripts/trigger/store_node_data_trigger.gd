extends Trigger

@export var node: Node
@export var property_path: String
@export var data_property_path: String

func execute():
	var property = node.get(property_path)
	assert(property, "property path is invalid")
	assert(GlobalData.get(data_property_path) != null, "data property path is invalid")
	GlobalData.set(data_property_path, property)
