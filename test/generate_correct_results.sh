#!/bin/sh
CGN_PHASES=5
for i in $(seq 1 $CGN_PHASES); do
    TEST_FILE=cgn_phase${i}_test.xml
    RESULT_FILE=cgn_phase${i}_test_expected.xml
    ../tools/cgn_preprocess.sh $TEST_FILE $i > $RESULT_FILE
done

# type counts test
../tools/cgn_run_template.sh cgn_type_counts_test.xsl create-type-counts-xml-test cgn_type_counts_test.xml > cgn_type_counts_test_expected.xml

JCGN_PHASES=5
for i in $(seq 1 $JCGN_PHASES); do
    TEST_FILE=jcgn_phase${i}_test.xml
    RESULT_FILE=jcgn_phase${i}_test_expected.xml
    ../tools/jcgn_preprocess.sh $TEST_FILE $i > $RESULT_FILE
done
