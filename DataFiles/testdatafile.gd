class_name PromptFile extends Node


var array1: PackedStringArray = (["hello", "world"])
var array2: PackedStringArray = (["how", "are", "you", "doing", "today"])
var array3: PackedStringArray = (["salvatore", "is", "turning", "18"])
var array4: PackedStringArray = (["I", "love", "you"])

var parent_array: Array = [array1, array2, array3, array4]

var rng := RandomNumberGenerator.new()

func _ready() -> void:
	pass

func RNG_prompt() -> int:
	var random_prompt_index := rng.randi_range(0, (parent_array.size() - 1))
	return random_prompt_index
