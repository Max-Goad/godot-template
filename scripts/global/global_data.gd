extends Node

### Save Data Variables
var saves: Array[SaveData]

var test_string: String

### Misc Variables
const max_save_slot_size: int = 7
const max_save_name_size: int = 20

### Engine Functions
func _ready() -> void:
	# saves.clear()
	# saves.resize(max_slot_size)
	# saves.fill(null)
	load_all_files()
	if save_exists(0):
		load_file(0)

### Saving / Loading Functions
func file_name(slot: int) -> String:
	return "user://save_data_%d.save" % slot

func save_exists(slot: int) -> bool:
	return FileAccess.file_exists(file_name(slot))

func save_file(slot: int, save_name = "Test"):
	var new_save = SaveData.new()
	new_save.save_name = save_name
	new_save.test_string = test_string
	#new_save.party.assign(party.map(func(a): return Avatar.serialize(a)))
	#new_save.bench.assign(bench.map(func(a): return Avatar.serialize(a)))

	var save_data_string = JSON.stringify(SaveData.serialize(new_save))
	var file = FileAccess.open(file_name(slot), FileAccess.WRITE)
	file.store_line(save_data_string)

	# The save data loaded into memory has to be updated too
	saves[slot] = new_save
	print("saved file to slot %d: %s" % [slot, save_data_string])

func can_load_file(slot: int):
	return slot < saves.size() and saves[slot] != null

# Deserialize
func load_file(slot: int):
	if slot >= saves.size() or saves[slot] == null:
		assert(false, "bad load")
		return
	clear()
	test_string = saves[slot].test_string
	# for d in saves[slot].party:
	# 	add_to_party(Avatar.deserialize(d))
	# for d in saves[slot].bench:
	# 	add_to_bench(Avatar.deserialize(d))
	print("loaded file from slot %d" % slot)


# Take all files and put their Dictionaries into memory
func load_all_files():
	saves.clear()
	saves.resize(max_save_slot_size)
	saves.fill(null)
	for slot in max_save_slot_size:
		if not save_exists(slot):
			continue
		var file = FileAccess.open(file_name(slot), FileAccess.READ)
		var save_string = file.get_line()
		var save_dict = JSON.parse_string(save_string)
		saves[slot] = SaveData.deserialize(save_dict)
		print("loaded slot %d from file: %s" % [slot, save_string])

func erase_file(slot: int):
	if not save_exists(slot):
		return
	DirAccess.remove_absolute(file_name(slot))
	saves[slot] = null

### Misc
func clear():
	pass
