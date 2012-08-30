#!/bin/bash

#$ -N sd_sid
#$ -S /bin/bash
#$ -o /people/bredin/logs/stdout/
#$ -e /people/bredin/logs/stderr/

SID=/people/barras/diarization/scripts/diarization-sid12.sh
SEG2MDTM=/people/barras/diarization/scripts/seg2mdtm

if [ -n "${SGE_TASK_ID+x}" ]; then

    STEP=${SGE_TASK_LAST}-${SGE_TASK_FIRST}+1
    FIRST=${SGE_TASK_ID}-${SGE_TASK_FIRST}+1

    LIST=$1
    INPUT_DIR=$2
    PLP_DIR=$3
    OUTPUT_DIR=$4
    
    NUMBER=`wc -l $LIST|awk '{print $1}'`
    
    for (( f=$FIRST; f<=$NUMBER; f=f+$STEP ))
    do
      URI=$(head -n ${f} ${LIST} |tail -n 1)
      ${SID} -ubmset pakita -iter 5 -stop 1.0 -plpdir ${PLP_DIR} ${INPUT_DIR}/${URI}.MPG.wav ${OUTPUT_DIR} ${OUTPUT_DIR}/${URI}.MPG.stage1.seg
      ${SEG2MDTM} < ${OUTPUT_DIR}/${URI}.MPG.stage2.seg > ${OUTPUT_DIR}/${URI}.MPG.mdtm
    done
else
    echo "What? diarization-sid12.sh -ubmset pakita -iter 5 -stop 1.0 -plpdir plpDir "
    echo "                           wavDir/$uri.MPG.wav outputDir outputDir/$uri.MPG.stage1.seg"
    echo "      for each $uri in uriList"
    echo "How? qsub -t 1-NSPLIT `basename $0` uriList wavDir plpDir outputDir"
    echo "Where?  stdout = /people/bredin/logs/stdout/"
    echo "        stderr = /people/bredin/logs/stderr/"
fi
