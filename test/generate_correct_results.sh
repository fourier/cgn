#!/bin/sh
../tools/cgn_preprocess.sh cgn_phase1_test.xml 1 > cgn_phase1_test_expected.xml
../tools/cgn_preprocess.sh cgn_phase2_test.xml 2 > cgn_phase2_test_expected.xml
../tools/cgn_preprocess.sh cgn_phase3_test.xml 3 > cgn_phase3_test_expected.xml
../tools/cgn_preprocess.sh cgn_phase4_test.xml 4 > cgn_phase4_test_expected.xml
../tools/cgn_preprocess.sh cgn_phase5_test.xml 5 > cgn_phase5_test_expected.xml

../tools/jcgn_preprocess.sh jcgn_phase1_test.xml 1 > jcgn_phase1_test_expected.xml
../tools/jcgn_preprocess.sh jcgn_phase2_test.xml 2 > jcgn_phase2_test_expected.xml
