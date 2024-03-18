/// @description Show params
if not mux_is_ready() then exit;
draw_text(16, 16, $"param: {mux_arranger(aud_bgm_test1).params.n}");
draw_text(16, 32, $"tension: {mux_arranger(aud_bgm_test2).params.tension}");

draw_set_color(c_black);

var _sep = 14;
var _i, _snd, _bank, _base;

#macro DRAW_THE_THINGY \
draw_text(32, _base - _sep, _bank.name);\
for(_i = 0; _i < _bank.capacity; _i++) {\
	draw_text(80, _base + _sep * _i, string(_i));\
	if not _bank.has_sound(_i) then continue;\
	_snd = _bank.get_sound(_i);\
	draw_text(96, _base + _sep * _i, $"[{_snd.inst}] {audio_get_name(_snd.index)} -- {_snd.playing ? "PLAYING" : "PAUSED"}, {_snd.pos}s/{_snd.length}s, Px{_snd.get_pitch_factor()}");\
}

_base = 96;
_bank = mux_bank_get("BGM");
DRAW_THE_THINGY

_base += 160;
_bank = mux_bank_get("SFX");
DRAW_THE_THINGY

_base += 160;
_bank = MUX_ALL;
DRAW_THE_THINGY

draw_set_color(c_white);