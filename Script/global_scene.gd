extends Node2D

# 全局变量

# 播放 UI 点击音效
@onready var click_audio_player = $UIClick

# 播放音符点击音效
@onready var hit_audio_player = $Hit


var selected_msc_cover = null

var selected_msc_title : String = ""

var default_msc_cover_path : String = "res://Resource/Img/17.png"

var default_adjustment : float = 0.0

var default_volume : int = 50

var default_msclist_path : String= "D:/MscList/"

var saved_adjustment : float = 0.0

var saved_volume :int = 50

var saved_msclist_path : String = "D:/MscList/"

var saved_difficulty : int = 1

var missing_count : int = 0

var perfect_count : int = 0

var good_count : int = 0

var score : int = 0

var bpm : float = 0

var bpp : int = 0

var dt : float = 0.0

var del : float = 0.0

var phara : int = 0

var is_running_note : bool = false

var dialog :Array = [
	"佬, 我亲爱的佬, 你怎么就是个纸片人啊😭",
	"哇她真的好会唱, 她唱到我心尖上",
	"她真的, 我真的",
	"不是的, 那是参数, 我自己刚画的参数, 我就在跟我自己玩, 什么都没有",
	"她真的好可爱，她真的好会唱，她为什么偏偏竟然是纸片人啊😭",
	"\"每一个梦都是个旋律　漫天回忆该如何去聆听\"",
	"\"至少在这一刻 热爱不问为何\"",
	"\"最暗淡的一个梦最为炽热\"",
	"\"追上光一刹那 我的心也融化\"",
	"\"是你的心声 是我的歌声 能听见吗我的呼唤\"",
	"\"你是信的开头 诗的内容 童话的结尾\"",
	"\"赏颗吻吧 然后 拥护这被遗忘山丘\"",
	"\"欢呼着 Bilibili 次元咒语 解开你心中的谜题\"",
	"\"机械的心率带动血肉的共鸣\"",
	"\"我对你依赖成迷 想不清哪些原理和原因\"",
	"\"你应该忘记了吧 天气晴朗 心里却潮湿的盛夏\"",
	"\"故事该从何说起 我开始将过去回忆\"",
	"\"哪些朋友会一直陪我 wow wow 我们都是弱小孩童\"",
	"\"固执地夏虫汲取着美梦解渴\"",
	"\"叮叮叮当QQ响起会是谁呢 nayo nayo\"",
	"\"深夜诗人跟我一起唱 我们啦啦啦啦啦\"",
	"\"好吧 万能的宇宙大人啊 告诉我未来会好吗\"",
	"\"白鸟过河滩 挥一挥一去不回还\"",
	"\"在心里 攥紧着 那微小 又虚无的 希望\"",
	"\"我的悲伤 是水做的 一个巨浪 心里凉的透透的\"",
	"\"我的脊背 融在地面 我面向着 那些以前\"",
	"\"我等春风吹过来 梨花朵朵盛开 水暖春江笑满园\"",
	"\"枪口抵那先生的头 告诉我谁去谁当留\"",
	"\"谁曾想 语言 能掀起这灾变 谁曾说 祸起萧墙是妄言\"",
	"\"琴瑟愿与 共沐春秋 滢溪潺潺 炊烟悠悠\"",
	"\"放弃了 再见了 做你身后影子久了 都忘了真实自我\"",
	"\"你的生命给了我一半 你的爱也给了我一半\"",
]

func _ready():
	click_audio_player.volume_db = linear_to_db(saved_volume * 0.02)
	hit_audio_player.volume_db = linear_to_db(saved_volume * 0.02)


func init() -> void:
	missing_count = 0
	perfect_count = 0
	good_count = 0
	selected_msc_title = ""


func set_volume(volume) -> void:
	saved_volume = volume
	_ready()


func play_click_audio() -> void:
	click_audio_player.play(0.0)


func play_hit_audio() -> void:
	hit_audio_player.play(0.0)


# 将拍子计算为音符的 y 坐标
func sec_to_length(sec) -> float:
	return 185 - 10 * 60 * ((sec) * 60 / bpm + dt + saved_adjustment)
