#!/bin/bash

source ~/Git/ros/kalibr_coral/devel/setup.bash;
export KALIBR_MANUAL_FOCAL_LENGTH_INIT="ENABLE"

TARGET=$(realpath $1);
BAG=$(realpath $2);
OUTPUT_DIR=$(realpath $3);

SYNC="$4";
MI_TOI="$5";
MIN_VIEWS_OUTLIER="$6";

IFS=',' read -ra MODELS <<< "$7"; declare -p MODELS;
IFS=',' read -ra TOPICS <<< "$8"; declare -p TOPICS;
IFS=',' read -ra VERBOSE <<< "$9"; declare -p VERBOSE;

if [ ${#MODELS[@]}=${#TOPICS[@]} ]
then
    END_ID=`expr ${#MODELS[@]} - 1`;
    for index in $(seq 0 1 ${END_ID})
    do
        OUTPUT_FOLDER="${OUTPUT_DIR}/mono_${TOPICS[index]}";
        [ -d ${OUTPUT_FOLDER} ] || mkdir -p ${OUTPUT_FOLDER};
        kalibr_calibrate_cameras --approx-sync ${SYNC} --mi-tol ${MI_TOI} --min-views-outlier ${MIN_VIEWS_OUTLIER} --dont-show-report ${VERBOSE[index]} --target ${TARGET} --bag ${BAG} --models ${MODELS[index]} --topics ${TOPICS[index]} --dump-folder ./dump --output-folder ${OUTPUT_FOLDER} --overwrite-dump;
    done
fi

