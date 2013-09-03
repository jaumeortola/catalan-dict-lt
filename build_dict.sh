#!/bin/bash
# sort
export LC_ALL=C && sort freeling.txt >freeling_sorted.txt
cp freeling_sorted.txt ./backups/freeling_$(date +%Y%m%d-%H%M%S).txt
rm freeling.txt
mv freeling_sorted.txt freeling.txt
# replace whitespaces with tabs
perl sptotabs.pl <freeling.txt >freeling_tabs.txt
# create list of used tags
gawk -f tags.awk freeling_tabs.txt | sort -u > catalan_tags.txt
# create tagger dictionary with morfologik tools
java -jar morfologik.jar tab2morph -inf -i freeling_tabs.txt -o freeling_morph.txt -annotation _
export LC_ALL=C && sort freeling_morph.txt | java -jar morfologik.jar fsa_build --sorted -f cfsa2 -o catalan.dict
# dump the tagger dictionary
java -jar morfologik.jar fsa_dump -d catalan.dict -x >catalan_lt.txt
# reorder columns for syntesis dictionary
gawk -f synthesis.awk freeling_tabs.txt >output2.txt
# create synthesis dictionary with morfologik tools
#java -jar morfologik.jar tab2morph -i output2.txt -o encoded.txt
perl morph_data_ca.pl <output2.txt >encoded.txt
export LC_ALL=C && sort encoded.txt | java -jar morfologik.jar fsa_build --sorted -f cfsa2 -o catalan_synth.dict
# dump synthesis dictionary
java -jar morfologik.jar fsa_dump -d catalan_synth.dict -x >catalan_synth_lt.txt
rm freeling_tabs.txt
rm freeling_morph.txt
rm output2.txt
rm encoded.txt
