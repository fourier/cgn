#!/bin/sh
echo Testing cgn:phase1
../tools/cgn_preprocess.sh cgn_phase1_test.xml 1 > cgn_phase1_test_result.xml
diff -q cgn_phase1_test_result.xml cgn_phase1_test_expected.xml
echo Testing cgn:phase2
../tools/cgn_preprocess.sh cgn_phase2_test.xml 2 > cgn_phase2_test_result.xml
diff -q cgn_phase2_test_result.xml cgn_phase2_test_expected.xml
echo Testing cgn:phase3
../tools/cgn_preprocess.sh cgn_phase3_test.xml 3 > cgn_phase3_test_result.xml
diff -q cgn_phase3_test_result.xml cgn_phase3_test_expected.xml
echo Testing cgn:phase4
../tools/cgn_preprocess.sh cgn_phase4_test.xml 4 > cgn_phase4_test_result.xml
diff -q cgn_phase4_test_result.xml cgn_phase4_test_expected.xml
echo Testing cgn:phase5
../tools/cgn_preprocess.sh cgn_phase5_test.xml 5 > cgn_phase5_test_result.xml
diff -q cgn_phase5_test_result.xml cgn_phase5_test_expected.xml
