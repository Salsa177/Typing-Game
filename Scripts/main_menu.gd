extends Control

@onready var main_menu: CenterContainer = %MainMenu
@onready var how_to_menu: CenterContainer = %HowToMenu
@onready var site_menu: CenterContainer = %SiteMenu
@onready var close_site: Button = %CloseSite
@onready var close_how_to: Button = %CloseHowTo
@onready var open_site: Button = %Website
@onready var open_how_to: Button = %HowToPlay
@onready var start: Button = %"Start Game"
@onready var exit: Button = %Exit
@onready var close_difficulty: Button = %CloseDifficulty
@onready var master_class: Button = %MasterClass
@onready var professional: Button = %Professional
@onready var advanced: Button = %Advanced
@onready var intermediate: Button = %Intermediate
@onready var beginner: Button = %Beginner
@onready var difficulty_select: CenterContainer = %DifficultySelect


func _ready() -> void:
	main_menu.visible = true
	how_to_menu.visible = false
	site_menu.visible = false
	difficulty_select.visible = false
	
	start.pressed.connect(difficulty_menu)
	exit.pressed.connect(close)
	close_how_to.pressed.connect(how_to)
	open_how_to.pressed.connect(how_to)
	open_site.pressed.connect(site)
	close_site.pressed.connect(site)
	close_difficulty.pressed.connect(difficulty_menu)
	
	beginner.pressed.connect(beginner_diff)
	intermediate.pressed.connect(intermediate_diff)
	advanced.pressed.connect(advanced_diff)
	professional.pressed.connect(professional_diff)
	master_class.pressed.connect(master_class_diff)
	

func play() -> void:
	get_tree().change_scene_to_file("res://Scenes/Typing_Game.tscn")


func close() -> void:
	get_tree().quit()


func how_to() -> void:
	if how_to_menu.visible:
		how_to_menu.visible = false
		main_menu.visible = true
	else:
		how_to_menu.visible = true
		main_menu.visible = false


func site() -> void:
	if site_menu.visible:
		site_menu.visible = false
		main_menu.visible = true
	else:
		site_menu.visible = true
		main_menu.visible = false


func difficulty_menu() -> void:
	if difficulty_select.visible:
		difficulty_select.visible = false
		main_menu.visible = true
	else:
		difficulty_select.visible = true
		main_menu.visible = false


func beginner_diff() -> void:
	TDF.diff = 1
	play()


func intermediate_diff() -> void:
	TDF.diff = 2
	play()


func advanced_diff() -> void:
	TDF.diff = 3
	play()


func professional_diff() -> void:
	TDF.diff = 4
	play()


func master_class_diff() -> void:
	TDF.diff = 5
	play()
