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


my $mol_index = 1;
my %DNA = ();
my $init_mol = 1000;
for my $i ( 1 .. $init_mol){
	my $name = "mol".$i;
	$DNA{$mol_index ++} = $name;
}

my $pcr_cycle = 15;
my $RATIO = 0.8;


for my $pcr (1 .. $pcr_cycle){

	my $ampli = int($RATIO * $mol_index );
	my $max = $mol_index;

	for my $index ( ($mol_index + 1) .. ($mol_index + $ampli)){
		my $sampling = $DNA{ int(rand($max)) + 1 };
		defined $sampling or $sampling = 1;
		$DNA{$mol_index ++} = $sampling;
	}

}

my %freq1 = ();
for my $index ( keys %DNA){
	defined $DNA{$index} or die "ERROR : $index \n";
	$freq1{$DNA{$index}} ++;
}

my %freq2 = ();
for my $freq (values %freq1){
	$freq2{$freq} ++;
}

for my $dupli (sort {$a <=> $b} keys %freq2){
	print "$dupli\t$freq2{$dupli}\n";
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

