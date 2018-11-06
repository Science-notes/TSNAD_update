#!/usr/bin/perl-w
# ******************** Software Information *******************
# Version: Somatic_Mutation_Detector 3.0
# File: mutect_filter.pl
# Perl Version: 5.18.2
# Finish time: Octobor, 2018.
# Developer: Jingcheng Wu, Zhan Zhou, Wenyi Zhao 
# Copyright (C) 2018-2019 - College of Pharmaceutical Sciences, 
#               Zhejiang University - All Rights Reserved 
# *************************************************************
use strict;

my $in=$ARGV[0]; #input mutect output file
my $out=$ARGV[1]; #output filtered mutations
my $tumor_reads_cutoff=$ARGV[3];
my $normal_reads_cutoff=$ARGV[4];
my $tumor_f_cutoff=$ARGV[5];
my $normal_f_cutoff=$ARGV[6];
my $tumor_alt_cutoff=$ARGV[7];

open IN, "<$in" or die "cannot open $in:$!";
open OUT, ">$out" or die "cannot open $out:$!";

while (<IN>){
	chomp;
	if ($_=~/#/){
		print OUT"$_\n" 
	}
	else{
		my @line=split/\t/,$_;
		my @tumor=split /:/, $line[10];
		my @normal=split /:/, $line[9];
		my $tumor_alt=(split /,/, $tumor[1])[1];
		my $normal_alt=(split /,/, $normal[1])[1];
		my $tumor_ref=(split /,/, $tumor[1])[0];
		my $normal_ref=(split /,/, $normal[1])[0];
		my $tumor_reads=$tumor_alt+$tumor_ref;
		my $normal_reads=$normal_alt+$normal_ref;
		my $tumor_f=$tumor_alt/$tumor_reads;
		if($tumor_reads >= $tumor_reads_cutoff && $normal_reads >= $normal_reads_cutoff && $tumor_f >= $tumor_f_cutoff && $tumor_alt >= $tumor_alt_cutoff && $normal_alt == 0){
			print OUT "$_\n";
		}
	}
	
}