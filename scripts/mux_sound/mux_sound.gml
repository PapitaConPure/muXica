/**
 * @desc Represends an audio block
 * @param {Asset.GMSound} index Sound asset index
 * @param {Id.Sound} inst Sound instance id
 * @param {Bool} keep_alive=false Whether to keep the sound alive after it reaches 0 gain (true) or not (false)
 * @constructor
 */
function MuxSound(index, inst) constructor {
	self.index = index;
	self.inst = inst;
}
