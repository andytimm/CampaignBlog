head -n 800000 my_voters.txt > voters.train
tail -n 200000 my_voters.txt > voters.test

./fasttext supervised -input voters.train -output fT_voters

./fasttext predict fT_voters.bin -

./fasttext test fT_voters voters.test

cat my_voters.txt | sed -e "s/\([.\!?,'/()]\)/ \1 /g" | tr "[:upper:]" "[:lower:]" > voters.preprocessed.txt
head -n 11981105 voters.preprocessed.txt > voters.pp.train
tail -n 1331233 voters.preprocessed.txt > voters.pp.valid

./fasttext supervised -input voters.pp.train -output model_pp_voters

./fasttext test model_pp_voters.bin voters.pp.valid

# With more epochs
./fasttext supervised -input voters.pp.train -output model_pp_voters -epoch 25

./fasttext test model_pp_voters.bin voters.pp.valid

./fasttext supervised -input voters.pp.train -output model_pp_voters -lr 1.0 -epoch 25 -wordNgrams 2 -bucket 200000 -dim 50 -loss hs
