extends Node

var prompt: PackedStringArray = TDF.parent_array.get(TDF.RNG_prompt())
var current_word: String
var current_prompt := prompt
@onready var prompt_label: RichTextLabel = $Prompt_Label
var current_index: int = 0
var player_input_string: String
var key_typed: String
var wpm_word_timer: float = 0
var wpm_stored_times: Array = []
var wpm_average: float
var wpm_PB: float
var backspace_buffer: int = 0
var test: String = "hello my name is the goat romeo and my love is juliet"
var timer_index: int = 0
var max_time: float = 10.0
var total_timer: float = 0
var can_control: bool = true


func _ready() -> void:
	current_index = 0
	print(current_prompt)
	print(current_index)
	print(prompt)
	
	current_word = prompt.get(current_index)
	prompt_label.text = "[center]" + current_word + "[/center]"
#" ".join(current_prompt)


func _process(delta: float) -> void:
	#print(test.split(" ", false))
	update_label()
	timing_typed_words(delta)
	#next_prev_word()


func get_prompt() -> void:
	pass


func update_label() -> void:
	if can_control == false:
		prompt_label.text = "words per minute: " + str(wpm_average)
	else:
		prompt_label.text = player_input_string


func _unhandled_key_input(event: InputEvent) -> void:
	if can_control == false:
		return
	
	if event is InputEventKey and not event.is_released():
		var typed_event := event as InputEventKey
		if Input.is_action_pressed("Backspace") and not player_input_string.is_empty():
			player_input_string = player_input_string.left(player_input_string.length() - 1)
		else:
			key_typed = PackedByteArray([typed_event.unicode]).get_string_from_utf8()
			player_input_string += key_typed
		#print("input: ", player_input_string)


func timing_typed_words(delta: float) ->void:
	var PIA: PackedStringArray = player_input_string.split(" ", 0)
	
	if can_control == true:
		wpm_word_timer = move_toward(wpm_word_timer, 10000, 1 * delta)
		total_timer = move_toward(total_timer, max_time, delta)
	else:
		wpm_calculator(wpm_stored_times)
		print(wpm_stored_times)
		wpm_word_timer = 0
		total_timer = 0
		return
	
	if current_index < 0:
		current_index = 0
	elif Input.is_action_pressed("Spacebar"):
		current_index = PIA.size()
	elif Input.is_action_pressed("Backspace"):
		current_index = PIA.size()

	if timer_index != current_index:
		if current_index == (wpm_stored_times.size() + 1):
			timer_index = current_index
			wpm_stored_times.append(wpm_word_timer)
			wpm_word_timer = 0
		elif current_index < (wpm_stored_times.size() + 1):
			timer_index = current_index
			wpm_stored_times.remove_at((wpm_stored_times.find(wpm_stored_times.back(), 0)))
		elif wpm_stored_times.size() == 0:
			timer_index = current_index
			wpm_stored_times.append(wpm_word_timer)
			wpm_word_timer = 0
	
	if total_timer >= max_time:
		can_control = false

	#print(" ")
	#print(current_index)
	#print(timer_index)
	#print(total_timer)
	#print(wpm_stored_times)
	#print(wpm_word_timer)


func wpm_calculator(wpm_times_array: Array) -> float:
	var word_count: int = wpm_times_array.size()
	wpm_average = 0.0
		
	wpm_average = word_count / (max_time / 60)
	
	if wpm_average > wpm_PB:
		wpm_PB = wpm_average
		
	return wpm_average
