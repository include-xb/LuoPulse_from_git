extends Node

var rootMscPath: String = "D:/MscList"

var mscPackList: Dictionary

# 这个变量缓存了谱面文件, 进入play_scene前需要读取谱面文件然后将文件 get_as_text() 到这个变量即可
var mscFile : String

# 音符流速, 玩家可调, 默认 10
var speed : int = 10
