//https://manual.gamemaker.io/monthly/en/GameMaker_Language/GML_Reference/Asset_Management/Audio/Audio_Effects/Audio_Effects.htm

function mux_config_banks() {
	//You can change the default sound bank audio emitter configuration here:
	/*MUX_DEFAULT_EMITTER.falloff = {
		distance_reference: 100_000_000,
		distance_maximum: 100_000_000,
		factor: 0
	};*/
	//MUX_DEFAULT_EMITTER.gain = 1;
	//MUX_DEFAULT_EMITTER.pitch = 1;
	//MUX_DEFAULT_EMITTER.position = [ 0, 0, 0 ];
	//MUX_DEFAULT_EMITTER.velocity = [ 0, 0, 0 ];
	//MUX_DEFAULT_EMITTER.listener_mask = 1;
	
	//You can define your own muXica sound banks here.
	//By default, a MuxBank "all" will be created. You shouldn't create another bank with that name.
	//Each one of the MuxBank created here will create and associate a new bus to it.
	//Every sound associated with a bank will play through that bus by default.
	//You can then access said bus and set its effects through the bank.bus attribute.
	//If you want to play a sound through a different emitter than the bus default, you can link the emitter to the bank through the mux_emitter_bank() function
	mux_bank_create("BGM", [
		aud_bgm_test1,
		aud_bgm_test2,
		aud_bgm_test3,
		aud_bgm_test4,
		aud_bgm_test5
	]);
	mux_bank_set_gain("BGM", 0.4);
	
	mux_bank_create("SFX", [ aud_sfx_test1 ]);
	mux_bank_set_gain("SFX", 0.4);
	
	//You can try this example effect for some nice reverb!
	//var _some_effect = audio_effect_create(AudioEffectType.Reverb1);
	//_some_effect.bypass = false;
	//_some_effect.size = 0.67;
	//_some_effect.damp = 0.58;
	//_some_effect.mix = 0.14;
	//mux_bank_get("all").bus.effects[0] = _some_effect;
}
