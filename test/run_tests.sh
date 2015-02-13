#!/bin/sh
../tools/cgn_preprocess.sh cgn_phase1_test.xml 1 > cgn_phase1_test_result.xml
diff -q cgn_phase1_test_result.xml cgn_phase1_test_expected.xml
