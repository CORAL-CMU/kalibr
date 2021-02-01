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

if [ ${#MODELS[@]}=${#TOPICS[@]} ]
then
    END_ID_0=`expr ${#MODELS[@]} - 2`;
    for index_0 in $(seq 0 1 ${END_ID_0})
    do
        START_ID_1=`expr ${index_0} + 1`;
        END_ID_1=`expr ${#MODELS[@]} - 1`;
        for index_1 in $(seq ${START_ID_1} 1 ${END_ID_1})
        do
            OUTPUT_FOLDER="${OUTPUT_DIR}/stereo_${TOPICS[index_0]}_${TOPICS[index_1]}";
            [ -d ${OUTPUT_FOLDER} ] || mkdir -p ${OUTPUT_FOLDER};
            kalibr_calibrate_cameras --approx-sync ${SYNC} --mi-tol ${MI_TOI} --min-views-outlier ${MIN_VIEWS_OUTLIER} --dont-show-report ${VERBOSE[index_0]} ${VERBOSE[index_1]} --target ${TARGET} --bag ${BAG} --models ${MODELS[index_0]} ${MODELS[index_1]} --topics ${TOPICS[index_0]} ${TOPICS[index_1]} --dump-folder ./dump --output-folder ${OUTPUT_FOLDER} --fixed-projection --fixed-distortion;
        done
    done
fi

OUTPUT_FOLDER="${OUTPUT_DIR}/all_in_one";
[ -d ${OUTPUT_FOLDER} ] || mkdir -p ${OUTPUT_FOLDER};
kalibr_calibrate_cameras --approx-sync ${SYNC} --mi-tol ${MI_TOI} --min-views-outlier ${MIN_VIEWS_OUTLIER} --dont-show-report --target ${TARGET} --bag ${BAG} --models ${MODELS[@]} --topics ${TOPICS[@]} ${VERBOSE[@]} --dump-folder ./dump --output-folder ${OUTPUT_FOLDER} --fixed-projection --fixed-distortion;
