head -n 800000 my_voters.txt > voters.train
tail -n 200000 my_voters.txt > voters.test

./fasttext supervised -input voters.train -output fT_voters

./fasttext predict fT_voters.bin -

./fasttext test fT_voters voters.test

cat my_voters.txt | sed -e "s/\([.\!?,'/()]\)/ \1 /g" | tr "[:upper:]" "[:lower:]" > voters.preprocessed.txt
head -n 11981105 voters.preprocessed.txt > voters.pp.train
tail -n 1331233 voters.preprocessed.txt > voters.pp.valid

./fasttext supervised -input voters.pp.train -output model_pp_voters



./fasttext predict-prob model_pp_voters.bin voters.pp.valid 5 > fT_baseline_preds.txt
