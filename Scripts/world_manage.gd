extends Node

var prompt = TDF.parent_array.get(TDF.RNG_prompt())
var current_word: String
var current_prompt = prompt
@onready var prompt_label: RichTextLabel = $Prompt_Label
var current_index: int = 0
var player_input


func _ready() -> void:
	current_index = 0
	print(current_prompt)
	print(current_index)
	print(prompt)
	
	current_word = prompt.get(current_index)
	prompt_label.text = "[center]" + current_word + "[/center]"
#" ".join(current_prompt)

func _process(delta: float) -> void:
	next_prev_word()


func get_prompt():
	pass

func next_prev_word():
	if Input.is_action_just_pressed("Spacebar") && current_index != (prompt.size() - 1):
		current_word = prompt.get(current_index + 1)
		current_index += 1
		print(current_index)
		prompt_label.text = "[center]" + current_word + "[/center]"
		print(current_word)
	elif Input.is_action_just_pressed("Backspace") && current_index != 0:
		current_word = prompt.get(current_index - 1)
		current_index -= 1
		print(current_index)
		prompt_label.text = "[center]" + current_word + "[/center]"
		print(current_word)
