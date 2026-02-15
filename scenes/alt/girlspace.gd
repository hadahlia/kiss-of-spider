extends Control


@onready var status_text: RichTextLabel = $StatusBox/VBox/StatusText
@onready var line_edit: LineEdit = $StatusBox/VBox/LineEdit

@onready var timer_label: Label = $TimerLabel

var god_time : float = 0

var QueryReply : Dictionary = {
	"ping": "pong!"
}

func _ready() -> void:
	status_text.text = ""
	
	line_edit.edit()

func _process(delta: float) -> void:
	god_time += delta
	var minutes :float= god_time / 60
	var seconds : float= fmod(god_time, 60)
	
	#var stringtest: String = "23:" + "22"
	var minute_string : String = ""
	if minutes >= 1:
		minute_string = "%02d:" % minutes
		minute_string = minute_string.erase(0)
	if minutes >= 10:
		minute_string = "%02d:" % minutes
	#else:
		#minute_string = ""
	
	var second_string: String
	
	if seconds >= 10 or minutes >= 1:
		second_string = "%02d" % seconds
	else:
		second_string = "%01d" % seconds
	
	var time_string: String = "T:" + minute_string + second_string
	#time_string = time_string.replace("0", "")
	
	timer_label.text = time_string


func add_line_to_status(line: String)->void:
	status_text.text += "\n" + line

# commands: USE <MOVENAMEE> (can omit use?)
# CHECK <MOVENAMEE> 
# ITEMS

func _on_line_submission(new_query: String) -> void:
	var unrecognized : String = "Unrecognized Query"
	
	var comm_arr :PackedStringArray= new_query.split(" ", true, 3)
	
	print(comm_arr.size())
	
	var reply :Variant= QueryReply.get(comm_arr[0], unrecognized)
	#if reply:
	
	
	add_line_to_status(reply)
	
	line_edit.text = ""
