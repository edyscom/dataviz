#!/usr/bin/perl


use strict;
use warnings;


$#ARGV == 0 or die "usage : $0 <merged_annotation_r1.txt>";

my %vdj = ();
my %v2d = ();
my %d2j = ();
my %v2j = ();
my %v_s = ();
my %d_s = ();
my %j_s = ();
my %header = ();
my $counter = 0;
open IN, $ARGV[0] or die "ERROR open $ARGV[0] \n";
while(<IN>){
	/^#/ and next;
	$counter ++;
	my @data = split(/\t/,$_);
	if($counter == 1){
		for my $i (0 .. $#data){
			$header{ $data[$i] } = $i;
		}
	}
	else{
		my $sample = $data[  $header{'Sample'} ];
		my $chain  = $data[  $header{'Chain'} ];
		my $V_type  = $data[  $header{'V_type'} ];
		my $D_type  = $data[  $header{'D_type'} ];
		my $J_type  = $data[  $header{'J_type'} ];
		$V_type eq "-" and next;
		$D_type eq "-" and next;
		$J_type eq "-" and next;
		$V_type !~ /\S/ and next;
		$D_type !~ /\S/ and next;
		$J_type !~ /\S/ and next;
		$V_type =~ /^(.+?)([-\/\*])/ and $V_type = $1;
		$D_type =~ /^(.+?)([-\/\*])/ and $D_type = $1;
		$J_type =~ /^(.+?)([-\/\*])/ and $J_type = $1;
	
		$chain =~ /(G|M)/ or next; ### NOTE: now only G/M analysis	
		$vdj{$sample}{$V_type}{$D_type}{$V_type} ++;
		$v2d{$sample}{$V_type}{$D_type} ++;
		$d2j{$sample}{$D_type}{$J_type} ++;
		$v_s{$sample}{$V_type} ++;
		$d_s{$sample}{$D_type} ++;
		$j_s{$sample}{$J_type} ++;
	}
}
close IN;


for my $sample (sort keys %vdj){
my @vs = sort keys %{$v_s{$sample}};
my @ds = sort keys %{$d_s{$sample}};
my @js = sort keys %{$j_s{$sample}};
	my $out = $sample.".vdjtable.txt";
	open OUT ,">$out" or die "ERROR open $out \n";
	print OUT "ID\t".join("\t",@ds)."\t".join("\t",@js)."\n";
	for my $v (@vs){
		my @vals = ();
		for my $d (@ds){
			defined $v2d{$sample}{$v}{$d} or  $v2d{$sample}{$v}{$d} = 0;
			push @vals, $v2d{$sample}{$v}{$d} ;
		}
		for my $j (@js){
			#defined $v2j{$sample}{$v}{$j} or  $v2j{$sample}{$v}{$j} = 0;
			#push @vals, $v2j{$sample}{$v}{$j} ;
			push @vals, 0;
		}
		print OUT "$v\t".join("\t",@vals)."\n";
	}
	for my $d (@ds){
		my @vals = ();
		for my $d (@ds){
			push @vals, 0 ;
		}
		for my $j (@js){
			defined $d2j{$sample}{$d}{$j} or  $d2j{$sample}{$d}{$j} = 0;
			push @vals, $d2j{$sample}{$d}{$j} ;
		}
		print OUT "$d\t".join("\t",@vals)."\n";
	}
	close OUT;
}



