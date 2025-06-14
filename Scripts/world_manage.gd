extends Node


var current_prompt: PackedStringArray
@onready var prompt_label: RichTextLabel = %Prompt_Label
@onready var typing_label: RichTextLabel = %Typing_Label
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
var max_time: float = 1000.0
var total_timer: float = 0
var can_control: bool = true
var changed_prompt: PackedStringArray


func _ready() -> void:
	current_index = 0
	get_prompt()
	print(current_prompt)
	print(current_index)
	print(current_prompt)


func _process(delta: float) -> void:
	#print(test.split(" ", false))
	timing_typed_words(delta)
	update_label()
	#next_prev_word()


func get_prompt() -> void:
	var prompt: PackedStringArray = TDF.parent_array.get(TDF.RNG_prompt())
	current_prompt = prompt


func update_label() -> void:
	if can_control == false:
		typing_label.text = "words per minute: " + str(wpm_average)
	else:
		set_type_label(current_prompt)


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
	elif PIA.size() < current_index:
		current_index = PIA.size()
	elif PIA.size() == current_index:
		if Input.is_action_pressed("Backspace") and (
			PIA.is_empty() == false) and (
			current_index != PIA.size() and (
			PIA.get(current_index).is_empty() == false)) and (
			len(PIA.get(current_index)) < len(changed_prompt.get(current_index))) and (
			len(PIA.get(current_index)) > 1):
				current_index = PIA.size()


func set_type_label(prompt: PackedStringArray) -> void:
	var PIA: PackedStringArray = player_input_string.split(" ", 0)
	var current_word := prompt.get(current_index)
	var char_index: int = 0
	#var current_char: String = changed_prompt.get(current_index).substr(char_index, 1)
	var word_length: int
	

	changed_prompt = prompt
	
	if (PIA.is_empty() == false) and (current_index != PIA.size()):
		changed_prompt = prompt
		
		
		if PIA.get(current_index).is_empty() == false:
			word_length = len(PIA.get(current_index))
			print(PIA.get(current_index).substr(word_length))
		
		if len(PIA.get(current_index)) > len(prompt.get(current_index)):
			changed_prompt.set(current_index, PIA.get(current_index))
		else:
			if PIA.get(current_index).is_empty() == false:
				changed_prompt.set(current_index, 
					str(PIA.get(current_index) + changed_prompt.get(current_index).erase(0, word_length)))
		
		#for char: String in changed_prompt.get(current_index):
			#if current_char == 
	
	
	typing_label.text = " ".join(changed_prompt)
	
	print(current_index)
	print(player_input_string)
	print(changed_prompt)
	print(prompt)
	print(current_prompt)


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
	
	if current_index >= current_prompt.size():
		current_index = current_prompt.size()
		can_control = false
	
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
