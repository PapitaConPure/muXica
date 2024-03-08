/// @description Show params
if mux_is_ready()
	draw_text(16, 16, $"param: {mux_arranger(aud_bgm_test1).params.n}");