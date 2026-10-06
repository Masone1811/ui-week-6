extends Node

const SAVE_PATH = "user://save_data.cfg"

var high_scores = []

var music_volume = 0.7
var sfx_volume = 0.8


func _ready():
	load_data()
	apply_audio_settings()

#High Scores
func add_score(time):
	high_scores.append(time)

	# Lowest to highest
	high_scores.sort()

	# Highest to lowest
	high_scores.reverse()

	# Only keep the best 5
	if high_scores.size() > 5:
		high_scores.resize(5)

	save_data()

#Audio Settings
func set_music_volume(value):
	music_volume = value

	var bus_index = AudioServer.get_bus_index("Music")

	if bus_index != -1:
		if value <= 0:
			AudioServer.set_bus_volume_db(bus_index, -80)
		else:
			AudioServer.set_bus_volume_db(bus_index, linear_to_db(value))

	save_data()


func set_sfx_volume(value):
	sfx_volume = value

	var bus_index = AudioServer.get_bus_index("SFX")

	if bus_index != -1:
		if value <= 0:
			AudioServer.set_bus_volume_db(bus_index, -80)
		else:
			AudioServer.set_bus_volume_db(bus_index, linear_to_db(value))

	save_data()


func apply_audio_settings():
	set_music_volume(music_volume)
	set_sfx_volume(sfx_volume)



#Save settings
func save_data():
	var config = ConfigFile.new()

	config.set_value("scores", "high_scores", high_scores)

	config.set_value("audio", "music_volume", music_volume)
	config.set_value("audio", "sfx_volume", sfx_volume)

	config.save(SAVE_PATH)


func load_data():
	var config = ConfigFile.new()

	if config.load(SAVE_PATH) != OK:
		return

	high_scores = config.get_value(
		"scores",
		"high_scores",
		[]
	)

	music_volume = config.get_value(
		"audio",
		"music_volume",
		0.7
	)

	sfx_volume = config.get_value(
		"audio",
		"sfx_volume",
		0.8
	)
