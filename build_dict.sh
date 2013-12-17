#!/bin/bash
# sort
export LC_ALL=C && sort diccionari.txt >diccionari_sorted.txt
#cp diccionari_sorted.txt ./backups/diccionari_$(date +%Y%m%d-%H%M%S).txt
rm diccionari.txt
mv diccionari_sorted.txt diccionari.txt
# replace whitespaces with tabs
perl sptotabs.pl <diccionari.txt >diccionari_tabs.txt
export LC_ALL=C && sort diccionari_tabs.txt >diccionari_tabs_sorted.txt
rm diccionari_tabs.txt
mv diccionari_tabs_sorted.txt diccionari_tabs.txt

# create list of used tags
#gawk -f tags.awk diccionari_tabs.txt | sort -u > catalan_tags.txt

# create tagger dictionary with morfologik tools
java -cp ~/lt/languagetool.jar org.languagetool.dev.POSDictionaryBuilder diccionari_tabs.txt catalan.info ca_wordlist.xml

cp /tmp/DictionaryBuilder*.dict ./catalan.dict
rm /tmp/DictionaryBuilder*.dict

# dump the tagger dictionary
java -cp ~/lt/languagetool.jar org.languagetool.dev.DictionaryExporter catalan.dict > catalan_lt.txt

# create synthesis dictionary with morfologik tools
java -cp ~/lt/languagetool.jar org.languagetool.dev.SynthDictionaryBuilder diccionari_tabs.txt catalan_synth.info

#cp /tmp/SynthDictionaryBuilder*_tags.txt ./catalan_tags.txt

cp /tmp/DictionaryBuilder*.dict ./catalan_synth.dict
rm /tmp/DictionaryBuilder*.dict

cp /tmp/SynthDictionaryBuilder*_tags.txt ./catalan_tags.txt
rm /tmp/SynthDictionaryBuilder*_tags.txt

# dump synthesis dictionary
java -cp ~/lt/languagetool.jar org.languagetool.dev.DictionaryExporter catalan_synth.dict > catalan_synth_lt.txt

rm diccionari_tabs.txt

#convert catalan_tags.txt to DOS file
sed 's/$'"/`echo \\\r`/" catalan_tags.txt > catalan_tags_dos.txt
rm catalan_tags.txt
mv catalan_tags_dos.txt catalan_tags.txt

