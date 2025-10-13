class_name SaveData extends Object

var save_name: String
var test_string: String

static func serialize(sd: SaveData) -> Dictionary:
	return {
		"save_name": sd.save_name,
		"test_string": sd.test_string
	}

static func deserialize(raw: Dictionary) -> SaveData:
	var out = SaveData.new()
	out.save_name = raw["save_name"]
	out.test_string = raw["test_string"]
	#out.party.assign(raw["party"])
	#out.bench.assign(raw["bench"])
	return out
