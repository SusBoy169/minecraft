extends Node

const Chunk = preload("res://scripts/chunk.gd")

func _ready():
	var chunk = Chunk.new()
	chunk.generate(0, 0)
	chunk.draw()
	add_child(chunk)
