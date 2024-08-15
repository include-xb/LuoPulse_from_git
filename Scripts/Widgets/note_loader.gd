extends Node

class_name  NoteLoader

func load_note_with_xml(scene : PlayScene, msc_file : String):
	var parser = XMLParser.new()
