#!/usr/bin/perl
#
use strict;

my $xform;
my $id;

my $prev = "";

my %libsh;

my $out;

my @dir_contents;

push( @dir_contents, $ARGV[0] ) if ("$ARGV[0]");

foreach (@dir_contents) {
    my $file = "$_";
    if ( !( ( $file eq "." ) || ( $file eq ".." ) ) ) {
        my $film = "$_";
        $film =~ s/DVDRip.*//i;
        $film =~ s/DVD.*//i;
        $film =~ s/R5.*//i;
        $film =~ s/iNTERNAL.*//i;
        $film =~ s/STV.*//i;
        $film =~ s/READNFO.*//i;
        $film =~ s/UNRATED.*//i;
        $film =~ s/EXTENDED.*//i;
        $film =~ s/LIMITED.*//i;
        $film =~ s/PROPER.*//i;
        $film =~ s/BRAZiLiAN.*//i;
        $film =~ s/CUSTOM.*//i;
        $film =~ s/\d\d\d\d.*//;
        $film =~ s/\(\d\d\d\d\).*//;
        $xform = $film;

        $xform =~ s/_/ /g;
        $xform =~ s/\./ /g;
        $xform =~ s/^ //g;
        chomp($xform);

        if ( $xform ne $prev ) {
            $out = `./imdb.pl -M "$xform" | head -1`;
            my ( $id, $title ) = split /:/, $out;
            if ( $id =~ m/\d/ ) {
                my ( $rating, $plot, $runtime );
                $libsh{$id}{id} = $id;
                $out = `./imdb.pl -D $id`;
                my @res = split /\n/, $out;
                foreach my $line (@res) {
                    $rating  = "$line" if ( $line =~ m/UserRating/ );
                    $plot    = "$line" if ( $line =~ m/Plot/ );
                    $runtime = "$line" if ( $line =~ m/Runtime/ );
                }
                chomp($title);
                $rating  =~ s/UserRating://;
                $plot    =~ s/Plot://;
                $runtime =~ s/Runtime://;
                print "$rating:$title:$runtime:$plot:DONE\n";
            }
            else {
                print "0.0:$film:0:$xform:DONE\n";
            }
        }
        $prev = $xform;

    }
}

