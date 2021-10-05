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


$#ARGV == 0 or die "program [overlap.R output table]";

my %color = (
"a1" => "red",
"a2" => "blue",
"a3" => "green",
"a4" => "yellow",
"a5" => "purple",
"a6" => "black",
"a7" => "pink",
"a8" => "grey",
"a9" => "orange",
"a10" => "magenta",
"a11" => "white",
"a12" => "red",
"a13" => "green",
"a14" => "blue",
"a15" => "red"
);

my $id = "-";
my $color = "-";
my %id2color = ();
open(IN,$ARGV[0]) or die "";
while(<IN>){
	chomp;
	if(/^>\s*(\S+)/ ){
		$id = $1;
		$color = $color{$id};
	}
	else{
		my @data = split(/\s+/,$_);
		for my $key (@data){
			$key =~ /\S/ or next;
			$id2color{$key} = $color;
		}
	}
}
close IN;

print "ID\tColor\n";
for my $key (sort keys %id2color){
	print "$key\t$id2color{$key}\n";
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

