extends Control

func _ready():
	%MenuContainer.visible = true
	%HighScores.visible = false
	%Settings.visible = false

	update_high_scores()

#Populate high scores
func update_high_scores():
	var labels = [
		%Score1,
		%Score2,
		%Score3,
		%Score4,
		%Score5
	]

	for i in range(labels.size()):
		if i < GameData.high_scores.size():

			var total_seconds = int(GameData.high_scores[i])

			var minutes = int(total_seconds / 60)
			var seconds = total_seconds % 60

			labels[i].text = "%d. %02d:%02d" % [
				i + 1,
				minutes,
				seconds
			]

		else:
			labels[i].text = "%d. --:--" % [i + 1]

func _on_play_button_pressed():
	get_tree().change_scene_to_file("res://Survivor Game.tscn")


func _on_high_scores_button_pressed():
	%HighScores.visible = true
	%MenuContainer.visible = false


func _on_settings_button_pressed():
	%Settings.visible = true
	%MenuContainer.visible = false


func _on_back_button_pressed():
	%HighScores.visible = false
	%MenuContainer.visible = true


func _on_settings_back_button_pressed():
	%Settings.visible = false
	%MenuContainer.visible = true


func _on_high_scores_back_button_pressed() -> void:
	%HighScores.visible = false
	%MenuContainer.visible = true
	

func _on_music_slider_value_changed(value):
	GameData.set_music_volume(value / 100.0)

func _on_sfx_slider_value_changed(value):
	GameData.set_sfx_volume(value / 100.0)
