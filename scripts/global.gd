extends Node

signal health_changed(current_health: int, max_health: int)
signal player_died
signal enemy_defeated
signal player_won

var player_current_attack = false
var current_scene = "world"
var transition_scene = false

var current_player_state = {
  "mod": false,
  "current_health": 3,
  "max_health": 3
}

func finish_change_scene():
  if transition_scene:

    transition_scene = false
    if current_scene == "world":
      current_scene = "interlude"
    elif current_scene == "interlude":
      current_scene = "world2"

