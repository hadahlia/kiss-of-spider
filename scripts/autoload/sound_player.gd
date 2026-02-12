extends Node

#var audiostream: AudioStreamPlayer

func get_sound():
	pass


func play_sound(sound: AudioStream)->AudioStreamPlayer:
	var audiostream := AudioStreamPlayer.new()
	audiostream.bus = "SFX"
	audiostream.max_polyphony = 3
	audiostream.stream = sound
	#add_child(audiostream)
	#audiostream.play()
	#audiostream.finished.connect(func()->void: audiostream.queue_free())
	return audiostream
