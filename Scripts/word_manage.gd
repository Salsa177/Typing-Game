extends Node

@onready var typing_label: RichTextLabel = %Typing_Label
@onready var underscore_label: RichTextLabel = %Underscore_Label
@onready var go_back_menu_button: Button = %GoBackMenu

var current_prompt: PackedStringArray
var current_index: int = 0
var player_input_string: String
var key_typed: String
var wpm_word_timer: float = 0
var wpm_stored_times: Array = []
var wpm_average: float
var accuracy: float = 0.0
var timer_index: int = 0
var max_time: float = 90.0
var total_timer: float = 0
var can_control: bool = true
var changed_prompt: PackedStringArray = []
var changed_words: PackedStringArray = []
var current_word: String


func _ready() -> void:
	current_index = 0
	current_prompt = get_prompt()
	print("\n \n \n \n ", current_prompt)
	go_back_menu_button.visible = false
	go_back_menu_button.pressed.connect(back_to_menu)


func _process(delta: float) -> void:
	timing_typed_words(delta)
	update_label(current_prompt)
	#print("CU: ", current_prompt)
	#print("")
	#print("CH: ", changed_prompt)


func get_prompt() -> PackedStringArray:
	var prompt: PackedStringArray = TDF.difficulty_array.get(TDF.RNG_prompt(TDF.diff))
	var index: int = 0
	
	
	for i: int in (prompt.size()):
		if prompt.get(i).left(17) != "[color=dark_gray]":
			prompt.set(i, "[color=dark_gray]" + prompt.get(i))
	
	#print(prompt)
	return prompt


func update_label(prompt: PackedStringArray) -> void:
	var prompt_string: String = " ".join(prompt)
	
	if can_control == false:
		not_in_control(prompt_string)
	else:
		set_type_label(current_prompt)


func _unhandled_key_input(event: InputEvent) -> void:
	var PIA: PackedStringArray = player_input_string.split(" ", 0)
	
	if can_control == false:
		return
	
	if event is InputEventKey and not event.is_released():
		var typed_event := event as InputEventKey
		if Input.is_action_pressed("Backspace") and not player_input_string.is_empty():
			player_input_string = player_input_string.left(player_input_string.length() - 1)
		else:
			if ((PIA.is_empty() == true) and (Input.is_action_just_pressed("Spacebar") == false)):
				key_typed = PackedByteArray([typed_event.unicode]).get_string_from_utf8()
				player_input_string += key_typed
			elif ((Input.is_action_just_pressed("Spacebar") == true) and ((
				player_input_string.right(1) == " ") == false) and (PIA.is_empty() == false)) and (
				PIA.get(current_index).length() >= current_word.length()):
					key_typed = PackedByteArray([typed_event.unicode]).get_string_from_utf8()
					player_input_string += key_typed
			elif ((PIA.is_empty() == false) and (Input.is_action_just_pressed("Spacebar") == false)):
				key_typed = PackedByteArray([typed_event.unicode]).get_string_from_utf8()
				player_input_string += key_typed
		#print("input: ", player_input_string)


func timing_typed_words(delta: float) -> void:
	var PIA: PackedStringArray = player_input_string.split(" ", 0)
	
	if can_control == true:
		wpm_word_timer = move_toward(wpm_word_timer, 10000, 1 * delta)
		total_timer = move_toward(total_timer, max_time, delta)
	else:
		wpm_calculator(wpm_stored_times)
		accuracy_calculator(current_prompt)
		wpm_word_timer = 0
		total_timer = 0
		return
	
	if current_index < 0:
		current_index = 0
	elif PIA.size() < current_index:
		current_index = PIA.size()
	elif PIA.size() == current_index:
		if Input.is_action_just_pressed("Backspace") and (
			current_index == 1) and (
			player_input_string.length() >= PIA.get(current_index - 1).length()):
				current_index = PIA.size() - 1
		elif (Input.is_action_just_pressed("Backspace") and (
			current_index != 0) and (
			player_input_string.length() > PIA.get(current_index - 1).length())):
				current_index = PIA.size() - 1
		elif Input.is_action_just_pressed("Backspace") and (
			PIA.is_empty() == false) and (
				
			current_index != PIA.size() and (PIA.get(current_index).is_empty() == false)) and (
				
			len(PIA.get(current_index)) <= len(changed_prompt.get(current_index))) and (
			len(PIA.get(current_index)) > 1):
				current_index = PIA.size()
	elif Input.is_action_just_pressed("Spacebar") and (
		player_input_string.right(PIA.get(current_index).length()).length() == PIA.get(current_index).length()) and (
		PIA.size() > current_index):
			current_index = PIA.size()
	elif (PIA.size() - 1) == current_index and (
		player_input_string.right(PIA.get(current_index).length()) != PIA.get(current_index)):
			current_index = PIA.size()
	
	if timer_index != current_index:
		if current_index == (wpm_stored_times.size() + 1):
			timer_index = current_index
			wpm_stored_times.append(wpm_word_timer)
			wpm_word_timer = 0
		elif current_index < (wpm_stored_times.size() + 1) and (PIA.size() - 1 != current_index):
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
	var word_length: int
	
	current_word = prompt_string.split(" ", 0).get(current_index).erase(0, 17)
	
	
	if PIA.size() <= 0:
		changed_prompt = prompt_string.split(" ", 0)
	
	
	if (PIA.is_empty() == false) and (current_index != PIA.size()):
		changed_prompt = prompt_string.split(" ", 0)
		
		if PIA.get(current_index).is_empty() == false:
			word_length = len(PIA.get(current_index))
		
		if len(changed_prompt.get(current_index)) > len(prompt.get(current_index)):
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
		if ((changed_words.size() == current_index + 1)):
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
		
	
	#sets the typing label
	
	typing_label.text = " ".join(changed_prompt).to_lower()
	underscore_label.text = "[color=#1b1b1b]" + (player_input_string).to_lower() + "[color=red]" + "_"
	
	if (current_index >= prompt_string.split(" ", 0).size() - 1) and (
		PIA.size() - 1 == current_index) and (current_index != prompt_string.split(" ", 0).size()):
			if len(PIA.get(current_index)) >= len(prompt_string.split(" ", 0).get(current_index).erase(0, 17)):
				timer_index = current_index
				wpm_stored_times.append(wpm_word_timer)
				wpm_word_timer = 0
				can_control = false
	elif (current_index >= prompt_string.split(" ", 0).size() - 1) and (
		PIA.size() - 1 == current_index) and (current_index != prompt_string.split(" ", 0).size()):
			if len(PIA.get(current_index)) >= len(prompt_string.split(" ", 0).get(current_index).erase(0, 17)):
				timer_index = current_index
				wpm_stored_times.append(wpm_word_timer)
				wpm_word_timer = 0
				can_control = false
	if (PIA.is_empty() == false):
		if ((prompt_string.split(" ", 0).size() == 1) and (
			player_input_string.length() >= prompt_string.erase(0, 17).length())):
				timer_index = current_index
				wpm_stored_times.append(wpm_word_timer)
				wpm_word_timer = 0
				can_control = false
	
	#print(changed_prompt.get(current_index).erase(0, 11))
	#print(changed_prompt.get(current_index).erase(0, 13))
	#print(prompt_string.split(" ", 0).get(current_index).erase(0, 17))
	#print(wpm_stored_times)


func wpm_calculator(wpm_times_array: Array) -> float:
	var word_count: int = wpm_times_array.size()
	var final_time: float = 0.0
	

	if word_count == 1:
		for i in wpm_times_array.size():
			final_time += wpm_times_array.get(i)
	else:
		for i in wpm_times_array.size() - 1:
			final_time += wpm_times_array.get(i)
	
	
	wpm_average = 0.0
	wpm_average = word_count / (final_time / 60)
		
	return wpm_average


func accuracy_calculator(prompt: PackedStringArray) -> float:
	var changed_prompt_string: String
	var no_colours_changed_prompt: PackedStringArray
	var original_prompt_string: String
	var no_colours_OG_prompt: PackedStringArray
	
	for i in changed_prompt.size() - 1:
		if changed_prompt.get(i).left(11) == "[color=red]":
			no_colours_changed_prompt.append(changed_prompt.get(i).erase(0, 11))
		elif changed_prompt.get(i).left(13) == "[color=white]":
			no_colours_changed_prompt.append(changed_prompt.get(i).erase(0, 13))
	
	for i in prompt.size() - 1:
		no_colours_OG_prompt.append(prompt.get(i).erase(0, 17))
	
	changed_prompt_string = " ".join(no_colours_changed_prompt)
	original_prompt_string = " ".join(no_colours_OG_prompt)
	
	
	accuracy = 0.0
	accuracy = original_prompt_string.similarity(changed_prompt_string) * 100
	
	if accuracy > 100:
		accuracy -= 10

	
	return accuracy


func not_in_control(prompt_resetter: String) -> void:
	typing_label.text = "WPM: " + str(snapped(wpm_average, 0.01)) + "\n ACC:  " + str(int(accuracy)) + "%"
	current_prompt = prompt_resetter.split(" ", 0)
	underscore_label.visible = false
	go_back_menu_button.visible = true


func back_to_menu() -> void:
	get_tree().change_scene_to_file("res://Scenes/Main_Menu.tscn")
