Shu0_word_reordering
=====================
This tool was developped by Shuo Li(http://nlp2ct.cis.umac.mo/~lishuo/), University of Macau.


The outline you can refer wiki.
Here I give you a example to show how this tool works.

you will have two scripts: 1st_reorder.pl and 2nd_replace_ali.pl

Example: we want to translate from French(corpus.fr) to English(corpus.en)
1. When you run the GIZA++ in the formal way, there will be a file (fr-en.A3.final.gz) in '-root-dir ~/train/my/de-en/giza.fr-en/'
Unpacked fr-en.A3.final.gz you will get fr-en.A3.final.
So you can applied the 1st_reorder.pl on fr-en.A3.final with -alignment  directory (~/train/my/de-en/giza.fr-en/fr-en.A3.final), -reordered corpus directory(./corpus.reofr).
After this step two files will be generated: corpus.reofr and oriali.txt(don't delete & record the alignment info)

2. applied the corpus.reofr and corpus.en agagin on the 2nd GIZA++, you will get another alignment file: reofr-en.A3.final
applied 2nd_replace_ali.pl on reofr-en.A3.final with -directory of reofr-en.A3.final, -directory of corpus.fr, directory of modified fr-en.A3.final
after this step, you will get a modified new fr-en.A3.final and you pack it into fr-en.A3.final.gz to update original one.

3. Run Moses step 3-9, based on the updated alignment information.
