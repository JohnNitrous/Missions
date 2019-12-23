extends Node2D

var file_path = "res://missions/"
var file_name = "mission1"
var file = file_path + file_name + ".dead"

var objectives

var counter: int = 0

var current_mission: int = 0
var current_objective: String

#HELPING FUNCTIONS

func array_to_string(array):
	var output = ""
	var output_counter = 1
	for value in array:
		if output == "":
			output += value
			output_counter += 1
		elif output_counter == array.size():
			output += " and " + value
			output_counter = 1
		else:
			output += ", " + value
			output_counter += 1
	return output

#UNDERSTAND WHAT THE COMMAND WANTS YOU TO DO

func get_objective(line):
	line = line.split("get ")
	line = line[1].split(",")
	current_objective = "GET_OBJECTIVE WAS CALLED. \n" + "Gather " + array_to_string(line)
	$Label.set_text(current_objective)

func arrive_area(line):
	line = line.split("arrive ")
	line = line[1].split(",")
	current_objective = "ARRIVE_AREA WAS CALLED. \n" + "Go to " + array_to_string(line)
	$Label.set_text(current_objective)

func activate_tool(line):
	line = line.split("activate ")
	line = line[1].split(",")
	current_objective = "ACTIVATE_TOOL WAS CALLED. \n" + "Activate " + array_to_string(line)
	$Label.set_text(current_objective)

func end_it_now(line):
	line = line.split("end ")
	line = line[1].split(",")
	file_name = "" + array_to_string(line)
	file = file_path + file_name + ".dead"
	objectives = load_file(file)
	current_mission = -1
	get_tree().change_scene(file)
	current_objective = "END_IT_NOW WAS CALLED \nShifting to " + file_name
	$Label.set_text(current_objective)
	return [objectives, current_mission]

#STUFF TO LOAD FROM THE FILE

func load_file(filepath):
	var file = File.new()
	file.open(filepath, File.READ)
	var content = file.get_as_text()
	file.close()
	var objectives = content.split("\n")
	for objective in objectives:
		if objective.begins_with("//"):
			objectives.remove(counter)
		else:
			counter +=1
	counter = 0
	return objectives

func interpret_objectives(objectives):
	if objectives[current_mission].begins_with("get"):
		get_objective(objectives[current_mission])
	elif objectives[current_mission].begins_with("arrive"):
		arrive_area(objectives[current_mission])
	elif objectives[current_mission].begins_with("activate"):
		activate_tool(objectives[current_mission])
	elif objectives[current_mission].begins_with("end"):
		end_it_now(objectives[current_mission])

func _ready():
	objectives = load_file("res://missions/mission1.dead")
	interpret_objectives(objectives)
	$Label.set_text(current_objective)
	set_process(true)

func _physics_process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		current_mission += 1
		interpret_objectives(objectives)
		#$Label.set_text(current_objective)