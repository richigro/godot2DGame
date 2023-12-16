extends Node

# a path in the player's local machine where data for this game is saved
const SAVE_FILE_PATH = "user://game.save"

var save_data: Dictionary = {
	"meta_upgrade_currency": 0,
	"meta_upgrades": {},
}


func _ready():
	GameEvents.experience_vial_collected.connect(on_experience_collected)
	load_save_file()

func load_save_file():
	if not FileAccess.file_exists(SAVE_FILE_PATH):
		return
	var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.READ)
	# load the data from user's computer to the in-game memory
	save_data = file.get_var()


func save():
	var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.WRITE)
	file.store_var(save_data)


func add_meta_upgrade(upgrade: MetaUpgrade):
	# if we don't have this meta upgrade yet
	if not save_data["meta_upgrades"].has(upgrade.id):
		save_data["meta_upgrades"][upgrade.id] = {
			"quantity": 0
		}
	
	save_data["meta_upgrades"][upgrade.id]["quantity"] += 1
	save()


func get_upgrade_count(upgrade_id: String):
	if save_data["meta_upgrades"].has(upgrade_id):
		return save_data["meta_upgrades"][upgrade_id]["quantity"]
	return 0


func on_experience_collected(number: float):
	save_data["meta_upgrade_currency"] += number