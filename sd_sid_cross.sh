#!/bin/bash

#$ -N sd_sid_cross
#$ -S /bin/bash
#$ -o /people/bredin/logs/stdout/
#$ -e /people/bredin/logs/stderr/

SID=/people/barras/diarization/scripts/diarization-sid12.sh
SEG2MDTM=/people/barras/diarization/scripts/seg2mdtm

EXPECTED_ARGS=3

if [ $# -ne $EXPECTED_ARGS ]
then
    echo "What? diarization-sid12.sh -ubmset pakita -iter 5 -stop 1.0 -cross -plpdir plpDir "
    echo "                           ${INPUT_DIR}/%s.wav ${OUTPUT_DIR}/all ${OUTPUT_DIR}/*.stage1.seg"
    echo "How? qsub `basename $0` wavDir plpDir outputDir"
else
    INPUT_DIR=$1
    PLP_DIR=$2
    OUTPUT_DIR=$3
    ${SID} -ubmset pakita -iter 5 -stop 1.0 -cross -plpdir ${PLP_DIR} ${INPUT_DIR}/%s.wav ${OUTPUT_DIR}/all ${OUTPUT_DIR}/*.stage1.seg
    ${SEG2MDTM} < ${OUTPUT_DIR}/all/cross.stop1.0.seg > ${OUTPUT_DIR}/all/diarization.mdtm
fi

