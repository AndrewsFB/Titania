extends Node2D

var mountain_peak = []


func _ready():
	mountain_peak.append("Não há dúvida. \nPela quantidade de monstros lá embaixo... \nTem que ser aqui!")
	mountain_peak.append("Não importa o quanto custe... \nNão importa quem se meta no meu caminho... \nEU FAREI TODOS SANGRAREM PELO QUE FIZERAM!")


func call_dialog(timeline):
	Global.cancel_player_input = true
	owner.hud.visible = false
	owner.modulate.a = 0.2
	var dialog = Dialogic.start(timeline)
	dialog.connect("timeline_end", self, "_dialog_ended")
	add_child(dialog)
	get_tree().paused = true


func _dialog_ended(param):
	owner.modulate.a = 1.0
	owner.hud.visible = true
	get_tree().paused = false
	yield(get_tree().create_timer(0.5, true), "timeout")
	Global.cancel_player_input = false
