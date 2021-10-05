#!/usr/bin/perl

use strict;
use warnings;

use Getopt::Long;
use Pod::Usage;
my $name = "";
my $flag = "";
my $result = GetOptions (
                        "name=s"   => \$name,      # name for 
                        "flag"  => \$flag) or pod2usage(2);  # flag  
 $#ARGV == -1  and  pod2usage(2);



#### Program for creating input expression matrix file for BioNet analysis
#### NGS normalized value is used for the matrix
#### NOTE!!!!    redundant ( symbol-entrezID) identifier is removed , first seen object is selected!!!) 



$#ARGV == 1 or die "program [Gene ID list table(header)] [gene list (DEG) ] ";

my %fil_list = ();
my $line_num = 0;
open(my $fh,$ARGV[0]) or die "ERROR to open $ARGV[0]\n";
while(<$fh>){
    chomp;
	$line_num ++;
	$line_num == 1 and next;
	my @data = split(/\t/,$_);
	$fil_list{$data[0]} = 1;	
}
close $fh;





my $ENTREZ_COL = 0;
my $SYMBOL_COL = 0;


#my $FC_THRESH = 2;
#my $FDR_THRESH = 0.05;


my %norm_col = ();
my @norm_cols = ();
my %seen_id = ();

my %pri = ();
open(IN,$ARGV[1]) or die "";
while(<IN>){
	/^#/ and next;
	chomp;
	my @data = split(/\t/,$_);
	if(/^Gene ID/ ){
		for my $i ( 0 .. $#data){
			$data[$i] =~ /^Entrez ID/ and $ENTREZ_COL = $i;
			$data[$i] =~ /^Gene Symbol/ and $SYMBOL_COL = $i;

			if($data[$i] =~ /(\S+)\(normalized\)/ ){
				my $sample_name = $1;
				$sample_name =~ /^\d+/ and $sample_name = "No".$sample_name;
				push @norm_cols, $sample_name;
				$norm_col{$i} = 1;
			}
		}
		my $norm_col = join("\t",@norm_cols);
		print "\t$norm_col\n";
		next;
	}

#	$data[2] <= $FDR_THRESH or next; ### NOTE  FDR must be less than FDR_THRESH
#	$data[4] >= $FC_THRESH or next; ### NOTE  FDR must be less than FDR_THRESH

	my $ens_id = $data[$ENTREZ_COL];
	my $symbol = $data[$SYMBOL_COL];


#defined $ens_id or next;
#$ens_id =~ /\S/ or next;
#$symbol =~ /\w/ or next;


	my $label = $symbol."($ens_id)";	
	
	defined $seen_id{$label} and next ; ##### NOTE ::   identifier redundancy is removed!
	$seen_id{$label} = 1;
	my @norm_vals = ();	
	for my $i ( 0 .. $#data){
		defined $norm_col{$i} and push @norm_vals , $data[$i];
	}

	my @not_na_value = grep {$_ > 0} @norm_vals;    #### NOTE :: ignore gene  if all values == ZERO , 
	#@not_na_value > 0 or next;
	
	my $norm_vals = join("\t",@norm_vals);
	 $pri{$data[0]} = $norm_vals;
}
close IN;


for my $id (sort keys %pri){	

defined $fil_list{$id}  or next;

	print "$id\t$pri{$id}\n";

}


__END__

=head1 NAME

    TEMPLATE - Using Getopt::Long and Pod::Usage

=head1 SYNOPSIS

    TEMPLATE.pl [options] [input file1] [input file2]

     Options:
       -name       some name
       -flag       some flag

=head1 OPTIONS

=over 8

=item B<-help>

    Print a brief help message and exits.

=item B<-man>

    Prints the manual page and exits.

=back

=head1 DESCRIPTION

    B<This program> will read the given input file(s) and do something
    useful with the contents thereof.

=cut

