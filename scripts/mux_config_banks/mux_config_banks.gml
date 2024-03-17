//You can define your own muXica sound banks here
//Each sound bank must be linked to a unique audio group you've previously created
//Every sound associated to the audio group you linked will automatically be added to a muXica sound bank
//https://manual.gamemaker.io/monthly/en/Settings/Audio_Groups.htm

function mux_config_banks() {
	mux_bank_add(BGM);
	mux_bank_add(SFX);
	
	mux_bank_set_gain(BGM, 0.4);
	mux_bank_set_gain(SFX, 0.4);
}
