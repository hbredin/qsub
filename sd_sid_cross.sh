#!/bin/bash

#$ -N sd_sid_cross
#$ -S /bin/bash
#$ -o /people/bredin/logs/stdout/
#$ -e /people/bredin/logs/stderr/

SID=/people/barras/diarization/scripts/diarization-sid12.sh
SEG2MDTM=/people/barras/diarization/scripts/seg2mdtm

EXPECTED_ARGS=4

if [ $# -ne $EXPECTED_ARGS ]
then
    echo "What? diarization-sid12.sh -ubmset pakita -iter 5 -stop 1.0 -cross -plpdir plpDir "
    echo "                           ${INPUT_DIR}/%s.wav ${OUTPUT_DIR}/listName ${OUTPUT_DIR}/*.stage1.seg"
    echo "How? qsub `basename $0` list wavDir plpDir outputDir"
else
    LIST=$1
    INPUT_DIR=$2
    PLP_DIR=$3
    OUTPUT_DIR=$4
    
    # Create combined listName/stage1.seg file
    listName=`basename ${LIST}`
    mkdir ${OUTPUT_DIR}/${listName}
    rm -f ${OUTPUT_DIR}/${listName}/stage1.seg
    for URI in `cat $LIST`
    do
      cat ${OUTPUT_DIR}/${URI}.MPG.stage1.seg >> ${OUTPUT_DIR}/${listName}/stage1.seg 
    done
    
    # Cross-show CLR diarization
    ${SID} -ubmset pakita -iter 5 -stop 1.0 -cross -plpdir ${PLP_DIR} ${INPUT_DIR}/%s.wav ${OUTPUT_DIR}/${listName} ${OUTPUT_DIR}/${listName}/stage1.seg

    # Format conversion
    ${SEG2MDTM} < ${OUTPUT_DIR}/${listName}/cross.stop1.0.seg > ${OUTPUT_DIR}/${listName}/diarization.mdtm
fi

