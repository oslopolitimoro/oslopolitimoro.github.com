#!/usr/bin/perl
# 20120927/JT
# Author: oslopolitimoro <kontakt@oslopolitimoro.org>
# Takes a csv as input file and puts out every tupel as markdown file
#   ready for octopress to deploy
#
# Requires Text::CSV, Getopt::Long, File::Slurp
#
# Syntax:
#	perl csv2markdown.pl -i <csvinputfile>
# Example:
#	perl csv2markdown.pl -i tweetsources.csv
# Output:
#	STDOUT: None, creates markdown files in the current folder though.
#
# ------------------------------------------------------------------------
use v5.10.1;
use strict;
use warnings;
use utf8;
use Getopt::Long;    # Handling parameters.
use Text::CSV;       # CSV file handling.
use File::Slurp;     # File handling
use streetmatch qw(:DEFAULT);  # Module for matching the streets from the tweets

# Fetch filename from command line
die usage() unless @ARGV;
Getopt::Long::Configure('bundling');
GetOptions( 'i|inputfile=s' => \my $inputfile );

# Read CSV File
my $csv = Text::CSV->new( { sep_char => ',', quote_char => '"' } );
my @content = read_file( $inputfile, { binmode => ':utf8' } );

foreach (@content) {
    next if m/^#/;
    if ( !$csv->parse($_) ) {
        warn "Failed to parse line: " . $csv->error_input;
        next;
    }
    generate_mkd_file_from( $csv->fields() );
}

sub usage {"Syntax:\n $0 -i|--inputfile <input.csv>\n"}

sub generate_mkd_file_from {
    my ( $date, $link, $title, $text ) = @_;

    # Map streetnames to Google Maps
    my @streetfiles = ('street.1.txt','street.2.txt');
    my @streetnames = streetmatch::grepstreetnames (@streetfiles);
    my %htmlmap = streetmatch::matchString2Street (@streetnames,$text);
    
    # Replace Street in Tweet with link to Google Maps
    $text =~ s/\${htmlmap{name}}/"\[$htmlmap{name}\]\[$htmlmap{link}\]/g;
    
    my $content = read_file( \*DATA );    # Get template from __DATA__
    $content =~ s/\<title\>/$title/ig;
    $content =~ s/\<time\>/$date/ig;
    $content =~ s/\<text\>/$text/ig;
    $content =~ s/\<link\>/$link/ig;
    $content =~ s/\<map\>/${htmlmap{iframe}}/ig;

    # Make markdownlinks of the text if available
    $content =~ s|\s(http://[^\s]+)| \[$1\]($1)|;
    
    # Link paragraphs to the norwegian law
    $content =~ s|§\s?(\d{1,4})|\[§ $1\](http://www.lovdata.no/all/hl-19020522-010.html#$1)|gi;

    # Build up filename and remove everything that doesn't belong there.
    my $filename = $date . "-" . lc($title);
    $filename =~ s/\s\d{1,2}:\d{2}//;
    $filename =~ s/å/aa/gi;
    $filename =~ s/ø/oe/gi;
    $filename =~ s/æ/ae/gi;
    $filename =~ s/ü/ue/gi;
    $filename =~ s/ö/oe/gi;
    $filename =~ s/ä/ae/gi;
    $filename =~ s/\s+/_/g;
    $filename =~ s/[\;\:\,\.]+//g;
    $filename =~ s/\_+$//ig;
    $filename .= ".mkd";

    write_file( $filename, { binmode => ':utf8' }, $content );
}

__DATA__
---
layout: post
title: "<title>"
date: <time>
comments: true
categories: 
---
<map>
> <text>
- [Operasjonssentralen](<link>)
