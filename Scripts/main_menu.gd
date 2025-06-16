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



func _ready() -> void:
	main_menu.visible = true
	how_to_menu.visible = false
	site_menu.visible = false
	
	start.pressed.connect(play)
	exit.pressed.connect(close)
	close_how_to.pressed.connect(how_to)
	open_how_to.pressed.connect(how_to)
	open_site.pressed.connect(site)
	close_site.pressed.connect(site)


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
