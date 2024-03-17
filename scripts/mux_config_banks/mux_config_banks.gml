//You can define your own muXica sound banks here
//Each sound bank must be linked to a unique audio group you've previously created
//Every sound associated to the audio group you linked will automatically be added to a muXica sound bank
//https://manual.gamemaker.io/monthly/en/Settings/Audio_Groups.htm

function mux_config_banks() {
	//Default audio emitter configuration
	//This emitter sends audio signals to the master bus
	audio_emitter_bus(MUX_DEFAULT_EMITTER, audio_bus_main);
	audio_emitter_falloff(MUX_DEFAULT_EMITTER, 100_000_000, 100_000_000, 0);
	
	//Add new MuxBanks here.
	//By default, a MuxBank "all" will be created. You shouldn't create another one with that name
	//Each one of the MuxBank created here will create a new bus.
	//You can then set effects and volume for that bank using the bank.bus attribute or the mux_bank_set_gain() function
	mux_bank_add("BGM");
	mux_bank_link("BGM", aud_bgm_test1);
	mux_bank_link("BGM", aud_bgm_test2);
	mux_bank_link("BGM", aud_bgm_test3);
	mux_bank_link("BGM", aud_bgm_test4);
	mux_bank_link("BGM", aud_bgm_test5);
	mux_bank_set_gain("BGM", 0.4);
	
	mux_bank_add("SFX");
	mux_bank_link("SFX", aud_sfx_test1);
	mux_bank_set_gain("SFX", 0.4);
	
	//You can try this example effect for some nice reverb
	var _some_effect = audio_effect_create(AudioEffectType.Reverb1);
	_some_effect.bypass = false;
	_some_effect.size = 0.67;
	_some_effect.damp = 0.58;
	_some_effect.mix = 0.14;
	mux_bank_get("all").bus.effects[0] = _some_effect;
}
