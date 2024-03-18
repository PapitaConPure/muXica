//How many frames to wait before concluding a crossfade event
#macro MUX_CROSSFADE_DELAY 1

//How many crossfade events can occur in parallel within the delay window.
//Note that if the limit is exceeded, some crossfades will not be performed,
//but a higher limit also means less performance
#macro MUX_CROSSFADE_PARALLEL_LIMIT 8
