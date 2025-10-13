extends Trigger

@export var value: int
@export var data_property_path: String

func execute():
	assert(GlobalData.get(data_property_path) != null, "data property path is invalid")
	GlobalData.set(data_property_path, value)
	pass
