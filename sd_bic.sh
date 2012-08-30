#!/bin/bash

#$ -N sd_bic.sh
#$ -S /bin/bash
#$ -o /people/bredin/logs/stdout/
#$ -e /people/bredin/logs/stderr/

BIC=/people/barras/diarization/scripts/diarization-bic11.sh

if [ -n "${SGE_TASK_ID+x}" ]; then

    STEP=${SGE_TASK_LAST}-${SGE_TASK_FIRST}+1
    FIRST=${SGE_TASK_ID}-${SGE_TASK_FIRST}+1

    LIST=$1
    INPUT_DIR=$2
    PLP_DIR=$3
    OUTPUT_DIR=$4
    UEM=$5
    
    NUMBER=`wc -l $LIST|awk '{print $1}'`
    
    for (( f=$FIRST; f<=$NUMBER; f=f+$STEP ))
    do
      URI=$(head -n ${f} ${LIST} |tail -n 1)
      
      # Generate "local" UEM file if needed
      # Make sure .MPG is added
      if [ -n "$UEM" ]; then
	  uem=`mktemp`
	  grep ${URI} ${UEM}| awk '{print $1 ".MPG " $2 " " $3 " " $4 }' > ${uem}
      else
	  uem=""
      fi
      ${BIC} -plpdir ${PLP_DIR} ${INPUT_DIR}/${URI}.MPG.wav ${OUTPUT_DIR} ${uem}

    done
else
    echo "What? diarization-bic11.sh -plpdir plpdir wavDir/$uri.MPG.wav outputDir [uem]"
    echo "      for each $uri in uriList"
    echo "How? qsub -t 1-NSPLIT `basename $0` uriList wavDir plpDir outputDir [uem]"
    echo "Where?  stdout = /people/bredin/logs/stdout/"
    echo "        stderr = /people/bredin/logs/stderr/"
fi
