#!/bin/sh
EXPECTED_DIR=expected
INPUT_DIR=input_data
CGN_PHASES=5
for i in $(seq 1 $CGN_PHASES); do
    TEST_FILE=$INPUT_DIR/cgn_phase${i}_test.xml
    RESULT_FILE=$EXPECTED_DIR/cgn_phase${i}_test_expected.xml
    ../tools/cgn_preprocess.sh $TEST_FILE $i > $RESULT_FILE
done

# type counts test
../tools/cgn_run_template.sh cgn_type_counts_test.xsl create-type-counts-xml-test $INPUT_DIR/cgn_type_counts_test.xml > $EXPECTED_DIR/cgn_type_counts_test_expected.xml

JCGN_PHASES=7
for i in $(seq 1 $JCGN_PHASES); do
    TEST_FILE=$INPUT_DIR/jcgn_phase${i}_test.xml
    RESULT_FILE=$EXPECTED_DIR/jcgn_phase${i}_test_expected.xml
    ../tools/jcgn_preprocess.sh $TEST_FILE $i > $RESULT_FILE
done
