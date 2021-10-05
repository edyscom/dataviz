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



### making all sample-pairs Scatter plot for TMM normalized expression signal 
###  NEW vs OLD experiments
### INPUT = Genes_Without_New_Partitions.txt  (New , Old)


$#ARGV == 1 or die "program [NEW gene Quantif] [OLD gene Quantif]";
my $R_scr = "scatter_plot_norm.R.templ";


my $file1 = $ARGV[0];
my $file2 = $ARGV[1];

my %lst = ();
open(IN,$ARGV[0]) or die "";
while(<IN>){
	chomp;
	my @data = split(/\t/,$_);
	if(/^Gene ID/){
		my @index_list = grep { $data[$_] =~ /normalized/ } 0 .. $#data;

		for my $i (@index_list){
			my $name = $data[$i];
			my $sample = $name;
			$sample =~ s/\(normalized\)//;
			
			my $val_file = make_combine($file1,$file2,$i,$sample);	
			exec_R($R_scr,$val_file,$sample);	
		}
	}
}
close IN;


sub exec_R{
	my $tmp_R = shift;
	my $val_file = shift;
	my $sample = shift;

	my $R_scr = "scatter_plot_norm.R";	
	open(OUT,">$R_scr");
   open(my $fh,$tmp_R) or die "ERROR to open $tmp_R\n";
    while(<$fh>){
		s/__SAMPLE__/$sample/g;
		s/__FILE__/$val_file/g;
		print OUT $_;
    }
    close $fh;
	close OUT;

	system("R --vanilla < $R_scr");

	unlink $R_scr;
return;
}

sub make_combine{
my $file1 = shift;
my $file2 = shift;
my $EXT_COLUMN = shift;
my $sample = shift;

my $combined_norm_val = "$sample"."_norm.txt";

open(OUT,">$combined_norm_val");

my %lst = ();
open(IN,$file1) or die "";
while(<IN>){
        chomp;
        /^#/ and next;
        /^Gene ID/ and next;
        my @data = split(/\t/,$_);
        my $fc = $data[$EXT_COLUMN];
        $lst{$data[0]} = $fc;
}
close IN;

print OUT "Gene ID\tval1\tval2\n";
open(IN,$ARGV[1]) or die "";
while(<IN>){
        chomp;
        my @data = split(/\t/,$_);
        /^#/ and next;

        defined $lst{$data[0]} and $lst{$data[0]} == 0 and $data[$EXT_COLUMN] == 0 and next; ###NOTE:  Skip all-zero data

        defined $lst{$data[0]} and print OUT "$data[0]\t$lst{$data[0]}\t$data[$EXT_COLUMN]\n";

}
close IN;
close OUT;


return $combined_norm_val;

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

