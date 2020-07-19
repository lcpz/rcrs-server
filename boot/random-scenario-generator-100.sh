#!/bin/bash

function myexecute {
    bash -c "$2 2>&1"
}

CURR_DIR=$(pwd)

[[ ! -d "$CURR_DIR/random-scenarios" ]] && mkdir $CURR_DIR/random-scenarios

cd `dirname $0`

. utils.sh
. functions.sh

LOGDIR='logs'
MAP_DIR=$1

if [[ ! -z "$MAP_DIR" ]]
then
    MAP_DIR=$(abspath $MAP_DIR)
    [[ -z "$MAP_DIR" ]] && exit 1
fi


echo "starting randomScenarioGenerator..."

makeClasspath $BASEDIR/jars $BASEDIR/lib

for i in {1..100}
do
    myexecute random-scenario-editor "java -cp $CP -Dlog4j.log.dir=$LOGDIR gis2.RandomScenarioGenerator $MAP_DIR $*"
    [[ -z "$MAP_DIR" ]] && break
    scenario_name="scenario-$(printf "%03d" $i).xml"
    cp -f "$MAP_DIR/scenario.xml" "$CURR_DIR/random-scenarios/$scenario_name"
    echo $scenario_name
done

# ./random-scenario-generator-100.sh ../maps/gml/paris/map -civ 0 0 -pf 0 0 -po 0 0 -at 0 0 -refuge 0 0 -fs 4 4 -fb 40 40 -fire 10 10
