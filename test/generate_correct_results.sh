#!/bin/sh
CGN_PHASES=5
for i in $(seq 1 $CGN_PHASES); do
    TEST_FILE=cgn_phase${i}_test.xml
    RESULT_FILE=cgn_phase${i}_test_expected.xml
    ../tools/cgn_preprocess.sh $TEST_FILE $i > $RESULT_FILE
done

JCGN_PHASES=5
for i in $(seq 1 $JCGN_PHASES); do
    TEST_FILE=jcgn_phase${i}_test.xml
    RESULT_FILE=jcgn_phase${i}_test_expected.xml
    ../tools/jcgn_preprocess.sh $TEST_FILE $i > $RESULT_FILE
done
