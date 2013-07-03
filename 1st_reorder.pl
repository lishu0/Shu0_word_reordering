#!/usr/bin/perl
###Give the dir of 1.alignment_file & 2.reordered_corpus_file in the cmd!
###This is the 2.0 version which consider the NULL({$x}) situation! put the $x in front of $x-1!
###And the code were modified to let the 3 arraies in memory!
###Last modified 19/04/2013 by Shuo Li
print "Written by Shuo Li, University of Macau\n";
$start_time = (times)[0];
use utf8; 
use Encode;
use List::Util qw/max min/;
# use LWP::Simple;
# use warnings;
use open ":encoding(utf8)", ":std";
use Encode qw/encode/;

($alignment_file) = $ARGV[0];
($reorder_file) = $ARGV[1];
open ALI, "<:utf8", $alignment_file or die $!;
# open ALIOUTPUT, ">:utf8", "alioutput" or die $!;
# open COR, ">:utf8", "corpus" or die $!;
$a=0;#Corpus array
$b=0;#NULL array
$c=0;#Alignment array
while (<ALI>)
{
  if (/^NULL \(\{/)
  {
	chomp($_);
	m/^NULL\s\(\{(.*?)\s\}\)\s(.*?$)/;
	$null_id=$1; #null
	$align_id=$2; #align text
	$null_id=~s/^\s//g;            ###deal with 'NULL' case start
	$null_id_length=@null_id=split / /, $null_id;
	if ($null_id_length==0)
	{
		$null_store_two[$b][0]=$null_id[0];
		$b++;
	}
	else 
	{
		for ($n=0; $n< $null_id_length; $n++)
		{
			$null_store_two[$b][$n]=$null_id[$n];
		}
		$b++;
	}                                ###deal with 'NULL' case end
	chomp($align_id);
	
	$align_id=~s/\}\) .*? \(\{//g;
	$align_id=~s/^.*? \(\{ //;
	$align_id=~s/\(//g;
	$align_id=~s/\{//g;
	$align_id=~s/\)//g;
	$align_id=~s/\}//g;
	$align_id=~s/ +/ /g;
	$align_id=~s/^ +//g;
	$align_id=~s/ +/ /g;
	$align_id=~s/^ +//g;
	$align_id=~s/ $//g;
	$align_id_length=@align_id=split / /, $align_id;  ###alignment  start
	for ($n=0; $n< $align_id_length; $n++)
		{
			$align_store_two[$c][$n]=$align_id[$n];
		}
		$c++;     ###alignment  end
  }
  elsif (/^# Sen/)
  {
  }
  else
  {
    chomp($_);
	# s/\n$//g;
	$corpus_store_len=@corpus_store=split / /, $_;
	for ($n=0; $n < $corpus_store_len; $n++)
	{
		$corpus_store_two[$a][$n]=$corpus_store[$n];     #put the corpus into a two-dimension array!
	}
	$a++; 
  }
}
print "Corpus, case of \"NULL ({ x x })\", Alignment Extraction---Done\n";
close (ALI);
$m=0;
print $a.' '.$b.' '.$c."\n";
if ($a==$b && $b==$c)
{
	open ALIOUTPUTNUM, ">:utf8", "reordered_tmp" or die $!;
	open ORIALI, ">:utf8", "oriali.txt" or die $!;
	$a=0;
	$count1=0;
	$count2=0;

	for ($n=0; $n< $b; $n++)
	{
		$max = max @{$align_store_two[$n]};
		# print $max;
		if (!$null_store_two[$n][0])   #NULL is null
		{
			$tmp_align_len=@tmp=@{$align_store_two[$n]}; 
			for ($m=0; $m < $tmp_align_len; $m++)
			{
				if($align_store_two[$n][$m] > $align_store_two[$n][$m+1])
				{
					$count1++;
				}
				$id_num=$align_store_two[$n][$m]-1;
				print ORIALI $align_store_two[$n][$m]." ";
				print ALIOUTPUTNUM $corpus_store_two[$n][$id_num]." ";
			}
			print ALIOUTPUTNUM "\n";
			print ORIALI "\n";
		}
		else
		{
			$tmp_null_len=@tmp=@{$null_store_two[$n]};
			for ($m=0; $m < $tmp_null_len; $m++)
			{
				$count_id=0;
				# $null=$null_store_two[$n][$m]-1;
				$null=$null_store_two[$n][$m]+1;
				if ($null==2)##
				{
					$newid=0;
					foreach $var_1 (@{$align_store_two[$n]})
					{
						$new_align_store_two[$n][0]=1;
						$new_align_store_two[$n][$newid+1]=$var_1;
						$newid++;
					}
					
				}
				else
				{
					foreach $var (@{$align_store_two[$n]})
					{
						if ($var==$null)
						{
							# $count_id++;
							last;
						}
						# print $var.' ';
						$count_id++;
					}
					# print $count_id;
					$newid=0;
					foreach $var_1 (@{$align_store_two[$n]})
					{
						# $new_align_store_two[$n][$newid]=$var_1;
						# $newid++;
						if ($null_store_two[$n][$m] > $max)
						{
							$new_align_store_two[$n][$null_store_two[$n][$m]-1]=$null_store_two[$n][$m];
						}
						elsif ($newid==$count_id)
						{
							$new_align_store_two[$n][$newid]=$null_store_two[$n][$m];
							# $new_align_store_two[$n][$newid+1]=$var_1;
							$newid++;	
							$new_align_store_two[$n][$newid]=$var_1;
							$newid++;
						}
						else
						{
							$new_align_store_two[$n][$newid]=$var_1;
							$newid++;
						}
					}
					
				}
				# foreach $var_1 (@{$align_store_two[$n]})
				# {
					# $new_align_store_two[$n][$newid]=$var_1;
					# $newid++;
					# if ($newid==$count_id)
					# {
						# $new_align_store_two[$n][$newid]=$null_store_two[$n][$m];
						# $new_align_store_two[$n][$newid+1]=$var_1;
						# $newid++;	
					# }
				# }
				@{$align_store_two[$n]}=@{$new_align_store_two[$n]};
				
			}

			$tmp_align_len=@tmp=@{$align_store_two[$n]};
			for ($x=0; $x < $tmp_align_len; $x++)
				{
					if($align_store_two[$n][$x] > $align_store_two[$n][$x+1])
					{
						$count1++;
					}
					$id_num=$align_store_two[$n][$x]-1;
					print ALIOUTPUTNUM $corpus_store_two[$n][$id_num]." ";
					print ORIALI $align_store_two[$n][$x]." ";
				}
				print ALIOUTPUTNUM "\n";
				print ORIALI "\n";
		
		}
	}
	close (ALIOUTPUTNUM);
	print "The original sequence was written in oriali.txt\n";
	print("The No. of reordered corpus is:".$count1."\n");
}
else
{
	print "ERROR with the $alignment_file!\n";
}
open ALIOUTPUTNUM, "<:utf8", "reordered_tmp" or die $!;
open OUTPUT, ">:utf8", $reorder_file or die $!;
while (<ALIOUTPUTNUM>)
{
	s/ +/ /g;
	s/ / /g;
	s/   / /g;
	print OUTPUT $_;
}
close (ALIOUTPUTNUM);
close (OUTPUT);
unlink("reordered_tmp");
$init_time = (times)[0] - $start_time;
print("Compilation time: $init_time seconds\n");

