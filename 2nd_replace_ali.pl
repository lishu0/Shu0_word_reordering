#!/usr/bin/perl

print "Written by Shuo Li, University of Macau\n";
$start_time = (times)[0];
use utf8; 
use Encode;
use Encode::CN;
# use LWP::Simple;
# use warnings;
binmode(STDIN, ':encoding(utf8)');
binmode(STDOUT, ':encoding(utf8)');
binmode(STDERR, ':encoding(utf8)');
use open ":encoding(utf8)", ":std";
use Encode qw/encode/;
########################################
($new_alignment_file) = $ARGV[0];
($corpus) = $ARGV[1];
($replaced_alignment_file) = $ARGV[2];
########################################
open TEXT, "<:utf8", $corpus or die $!;  #old
open TT, ">:utf8", $replaced_alignment_file or die $!;
$id=0;
while (<TEXT>)
{
  chomp();
    $store_kor[$id]=$_;
	$id++;
}
$id=0;
$num=0;
close (TEXT);
print "Read the $corpus---Done!\n";
open ORIALI, "<:utf8", "oriali.txt" or die $!;
$y=0;
while (<ORIALI>)
{
	chomp();
	$ori_id_length=@ori_id=split / /, $_;
	# print $ori_id_length."\n";
	for ($x=0; $x < $ori_id_length; $x++)
	{

		$ori_id_two[$y][$x]=$ori_id[$x];
	}
	$y++;
	
}
print "Indexing the location of $corpus---Done!\n";
$d=0;
$yy=0;
open REORDER_TEXT, "<:utf8", $new_alignment_file or die $!;  #reordered
while (<REORDER_TEXT>)
{
  if (/^#/)
  {
    print TT $_;
  }
  elsif (/^NULL/)
  {
	@newstore=();
	chomp();
	# s/\n$//g;
	$length=@string=split /\}\) /, $_;

	$string_ori=$store_kor[$num];
	# $string_ori=~s/\n$//g;
	# chomp($string_ori);
	$length_ori=@string_ori=split / /, $string_ori;

	for ($i=0; $i < $length; $i++)
	{
		if ($string[$i]=~/\(\{ \d*? /)
		{
			chomp($string[$i]);
			# $string[$i]=~s/\n$//g;
			$num_string=$string[$i];
			$num_string=~ /(^.*\(\{ )(.*)/;
			$string_word=$1;
			$string_num=$2;
			$string_num=~s/  / /g;
		
			# $string_num=~s/\n$//g;
			$length_num=@string_num=split / /, $string_num;
			
			for ($a=0; $a < $length_num; $a++)
			{
				# print $string_num[$a]."%";
				$newstore[$a]=$ori_id_two[$yy][$string_num[$a]-1];
				
				# for ($b=0; $b< $length_ori; $b++)
				# {
					# # @temp_store=();
					# if ($string_ori[$b] eq $reo_store_kor[$string_num[$a]-1])
					# {
						# $b++;
						# $newstore[$a]=$b;
						# # $temp_store[$c]=$b;
						# # $c++;
						# # print $b." ";
					# }

				# }
			}
			$new_string_num=join ' ', @newstore;
			@newstore=();

			print TT $1;
			print TT $new_string_num." }) ";

		}
		else 
		{
			print TT $string[$i]."}) ";
		}
	}
	$num++;
	print TT "\n";
	$yy++;

  }
  else 
  {
    chomp();
	$korlength=@reo_store_kor=split / /, $_;######array list!
	# print $korlength;
	print TT $store_kor[$id]." \n";
	$id++;
  }
  
}
close (TT);
# @store_kor=();
# @string=();
# @string_ori=();
# @string_num=();
# @newstore=();
# $id=0;
print "Replaced A3.final---Done!\n";
$init_time = (times)[0] - $start_time;
print("Compilation time: $init_time seconds\n");

