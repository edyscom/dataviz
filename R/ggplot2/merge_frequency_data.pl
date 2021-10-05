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
# $#ARGV == -1  and  pod2usage(2);

#$#ARGV == 0 or die "program [prefix]";


#my $prefix = $ARGV[0];


my @files = glob("read_count_S*.txt");

my %lst = ();
for my $file (@files){


my $line_n = 0;
open(IN,$file) or die "";
while(<IN>){
	chomp;
	/^#/ and next;  ### skip header
	my @data = split(/\t/,$_);
	$line_n++;
	if($line_n == 1){
		### do something for header line;
#		next;
	}
	$lst{$data[0]}{$file} = $data[1];
}
close IN;

}

my @head = ("ReadPerTag");
	for my $file (@files){
		my $name = "";
		$file =~ /read_count_(.+)\.txt/ and $name = $1;
		push @head , $name;
	}
#print join ("\t",@head)."\n";
	#
print "ReadsPerTag\tType\tFreq\n";
for my $readPerTag (sort {$a <=> $b} keys %lst){
	my @values = ($readPerTag);
	for my $file (@files){
		defined $lst{$readPerTag}{$file} or $lst{$readPerTag}{$file}=0;

		my $name = "";
		$file =~ /read_count_(.+)\.txt/ and $name = $1;
		print "$readPerTag\t$name\t$lst{$readPerTag}{$file}\n";
		push @values , $lst{$readPerTag}{$file};
	}
	#print join ("\t",@values)."\n";
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

