extends Node


var current_prompt: PackedStringArray
@onready var prompt_label: RichTextLabel = %Prompt_Label
@onready var typing_label: RichTextLabel = %Typing_Label
@onready var line_edit: LineEdit = %LineEdit
var current_index: int = 0
var char_index: int 
var player_input_string: String
var key_typed: String
var wpm_word_timer: float = 0
var wpm_stored_times: Array = []
var wpm_average: float
var wpm_PB: float
var backspace_buffer: int = 0
var timer_index: int = 0
var max_time: float = 1000.0
var total_timer: float = 0
var can_control: bool = true
var changed_prompt: PackedStringArray = []
var changed_words: PackedStringArray = []




func _ready() -> void:
	current_index = 0
	get_prompt()
	print(current_prompt)
	print(current_index)


func _process(delta: float) -> void:
	#print(test.split(" ", false))
	
	timing_typed_words(delta)
	update_label()
	#next_prev_word()


func get_prompt() -> void:
	var prompt: PackedStringArray = TDF.parent_array.get(TDF.RNG_prompt())
	var index: int = 0
	
	for i in prompt:
		prompt.set(index, "[color=dark_gray]" + prompt.get(index))
		index += 1
		
	current_prompt = prompt


func update_label() -> void:
	if can_control == false:
		not_in_control()
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
		wpm_word_timer = 0
		total_timer = 0
		return
	
	if current_index < 0:
		current_index = 0
	elif Input.is_action_just_pressed("Spacebar") and (
		player_input_string.right(PIA.get(current_index).length()).length() == PIA.get(current_index).length()) and (
		PIA.size() > current_index):
			current_index = PIA.size()
	elif PIA.size() < current_index:
		current_index = PIA.size()
	elif PIA.size() == current_index:
		if (Input.is_action_pressed("Backspace") and (
			current_index != 0) and (
			player_input_string.length() > PIA.get(current_index - 1).length())):
				current_index = PIA.size() - 1
				
		elif Input.is_action_pressed("Backspace") and (
			PIA.is_empty() == false) and (
				
			current_index != PIA.size() and (PIA.get(current_index).is_empty() == false)) and (
				
			len(PIA.get(current_index)) < len(changed_prompt.get(current_index))) and (
			len(PIA.get(current_index)) > 1):
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


func set_type_label(prompt: PackedStringArray) -> void:
	var PIA: PackedStringArray = player_input_string.split(" ", 0)
	var prompt_string: String = " ".join(prompt)
	var current_char: String
	var word_length: int
	
	
	if char_index == null:
		char_index = 0
	
	if PIA.size() <= 0:
		changed_prompt = prompt_string.split(" ", 0)
	
	
	if (PIA.is_empty() == false) and (current_index != PIA.size()):
		changed_prompt = prompt_string.split(" ", 0)
		
		
		if PIA.get(current_index).is_empty() == false:
			word_length = len(PIA.get(current_index))
		
		if len(PIA.get(current_index)) > len(prompt.get(current_index)):
			changed_prompt.set(current_index, PIA.get(current_index))
		else:
			if PIA.get(current_index).is_empty() == false:
				changed_prompt.set(current_index, 
					str("[color=white]" + PIA.get(current_index) + 
					changed_prompt.get(current_index).erase(0, word_length + 17)))
		
		# changes colours if words are correct or incorrect
		
		if (PIA.get(current_index).is_empty()):
			if changed_prompt.get(current_index).left(13) == "[color=white]":
				changed_prompt.set(current_index, changed_prompt.get(current_index).erase(0, 13))
				changed_prompt.set(current_index, "[color=dark_gray]" + changed_prompt.get(current_index))
				
			elif changed_prompt.get(current_index).left(11) == "[color=red]":
				changed_prompt.set(current_index, changed_prompt.get(current_index).erase(0, 11))
				changed_prompt.set(current_index, "[color=dark_gray]" + changed_prompt.get(current_index))
				
		elif (changed_prompt.get(current_index).erase(0, 13).to_lower()) != (
			prompt_string.split(" ", 0).get(current_index).erase(0, 17).to_lower()):
				changed_prompt.set(current_index, changed_prompt.get(current_index).erase(0, 13))
				changed_prompt.set(current_index, "[color=red]" + changed_prompt.get(current_index))
		
		# makes sure that colours and different letters stay when changing words
		# here they are being added/deleted from an array to store them
		
		if ((changed_words.size() - 1) < current_index):
			changed_words.append(changed_prompt.get(current_index).to_lower())
		elif ((changed_words.size() == current_index + 1)):
			if changed_words.get(current_index) != changed_prompt.get(current_index):
				changed_words.set(current_index, changed_prompt.get(current_index).to_lower())
		elif current_index < changed_words.size():
			if changed_words.get(current_index) != changed_prompt.get(current_index):
				changed_words.set(current_index, changed_prompt.get(current_index).to_lower())
		if changed_words.size() > current_index + 1:
			changed_words.resize(current_index + 1)
		
		# sets the colours/letters of previously typed words
		
		if current_index != 0:
			for i: int in (changed_words.size() - 1):
				if changed_prompt.get(i) != changed_words.get(i) and (i != current_index):
					changed_prompt.set(i, changed_words.get(i).to_lower())
		
	
	
	typing_label.text = " ".join(changed_prompt).to_lower()
	line_edit.text =  player_input_string
	
	
	if current_index >= current_prompt.size():
		current_index = current_prompt.size()
		can_control = false
	
	print(current_index)
	print(changed_words)
	print(PIA)


func wpm_calculator(wpm_times_array: Array) -> float:
	var word_count: int = wpm_times_array.size()
	wpm_average = 0.0
		
	wpm_average = word_count / (max_time / 60)
	
	if wpm_average > wpm_PB:
		wpm_PB = wpm_average
		
	return wpm_average


func not_in_control() -> void:
	typing_label.text = "words per minute: " + str(wpm_average)
	line_edit.visible = false
