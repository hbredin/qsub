qsub
====

Various "qsubable" scripts

wav16k.sh
---------

Extract audio from a video & convert it to 16k mono.
(uses ffmpeg & sndfile-resample)

sd_bic.sh
---------

Perform [full|uem] BIC speaker diarization

sd_sid.sh
---------

Perform mono-show SID speaker diarization
(using output of sd_bic.sh as input)