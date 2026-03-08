class_name State
extends Node

var active: bool = false
var state_controller: StateController

func enter():
	active = true
	on_enter()
	
func exit():
	on_exit()
	active = false


# Virtual functions
func on_enter():
	pass

func on_exit():
	pass

func process(_delta: float):
	pass
