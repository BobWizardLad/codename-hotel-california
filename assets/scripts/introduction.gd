extends Control

func _on_continue_pressed():
	$Door.show()
	$Hotel.hide()

func _on_start_pressed():
	$Door.hide()
	queue_free()

func _on_exit_pressed():
	get_tree().quit()
