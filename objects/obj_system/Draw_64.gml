/// @description Show params
if not mux_is_ready() then exit;

draw_text(16, 16, $"param: {mux_arranger(aud_bgm_test1).params.n}");
draw_text(16, 32, $"param: {mux_arranger(aud_bgm_test2).params.tension}");