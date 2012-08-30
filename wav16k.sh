#!/bin/bash

#$ -N wav16k
#$ -S /bin/bash
#$ -o /people/bredin/logs/stdout/
#$ -e /people/bredin/logs/stderr/
#$ -v LD_LIBRARY_PATH
#$ -v PATH

if [ -n "${SGE_TASK_ID+x}" ]; then

    STEP=${SGE_TASK_LAST}-${SGE_TASK_FIRST}+1
    FIRST=${SGE_TASK_ID}-${SGE_TASK_FIRST}+1

    LIST=$1
    INPUT_DIR=$2
    OUTPUT_DIR=$3

    NUMBER=`wc -l $LIST|awk '{print $1}'`

    for (( f=$FIRST; f<=$NUMBER; f=f+$STEP ))
    do

      RELATIVE=$(head -n ${f} ${LIST} |tail -n 1).MPG
      
      echo "[$f] stereo to mono + resampling 16k"

      # extract raw audio + stereo to mono
      ffmpeg -i ${INPUT_DIR}/${RELATIVE} -ac 1 ${OUTPUT_DIR}/${RELATIVE}.orig.wav
      # resample 16k
      sndfile-resample -to 16000 -c 0 ${OUTPUT_DIR}/${RELATIVE}.orig.wav ${OUTPUT_DIR}/${RELATIVE}.wav
      rm ${OUTPUT_DIR}/${RELATIVE}.orig.wav
      

    done
else
    echo "What? ffmpeg + sndfile-resample (16k)"
    echo "      for each video in videoList"
    echo "How? qsub -t 1-NSPLIT `basename $0` videoList inputDir outputDir"
    echo "Where?  stdout = /people/bredin/logs/stdout/"
    echo "        stderr = /people/bredin/logs/stderr/"
fi

