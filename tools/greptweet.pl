#!/usr/bin/perl
#
# Greeping the tweet content from Twitter user 'oslopolitiops' and output
# a csv line 
#
# Requires HTML::Treebuilder
# 
# Test-Tweet: http://twitter.com/oslopolitiops/statuses/250036062792085504
# ------------------------------------------------------------------------
use strict;
# use LWP::Simple;
use LWP::UserAgent;
use HTML::TreeBuilder;

sub usage {								# Routine prints the Syntax
	print "\n\nSyntax:
		script.pl: Tweet-URL				
		\n";
}

usage() && die "\n => Error: no URL specified. Abort.\n\n"
	unless ( @ARGV == 1);


my $ua = new LWP::UserAgent;
$ua->timeout(120);
my $url='http://twitter.com/oslopolitiops/statuses/250036062792085504';
my $request = new HTTP::Request('GET', $url);
my $response = $ua->request($request);
my $HTMLcontent = $response->content();
# print $HTMLcontent;

# Parse HTMLcontent
my $tree = HTML::TreeBuilder->new_from_content($HTMLcontent);
$tree->parse($HTMLcontent);
# Get Tweet Title
my ($title) = $tree->look_down('_tag','title');
# Get Tweet Text
my ($searchtext) = $tree->look_down('class','js-tweet-text');
# Get Tweet Timestamp line
my ($tweettimestamp) = $tree->look_down(
	'tag','a' and
	'class','tweet-timestamp js-permalink js-nav'	
);

my $HTMLTitle  = $title->as_text();
my $HTMLText = $searchtext->as_text();
my $HTMLTime = $tweettimestamp->as_HTML();
# Get the time stamp out of the line
$HTMLTime =~ m/title\=\"(\d{1,2}):(\d{1,2})\s(\w{2})\s\-\s(\d{1,2})\s(\w{3})\s(\d{2})\"/i;
my $hour = $1;
if ( lc($3) eq "pm" && $hour != 0 ){
	$hour += 12;
}
my $minute = $2;
print "TOD: $3\n";
my $day = $4;
my $year = "20".$6;

my %mon2num = qw(
    jan 1  feb 2  mar 3  apr 4  may 5  jun 6
    jul 7  aug 8  sep 9  oct 10 nov 11 dec 12
);
my $month = $mon2num{"$5"};
if ( length($month) eq 1) {$month = "0".$month};
$HTMLTime = $year."-".$month."-".$day." ".$hour.":".$minute; 

# Current problem:
# format HTMLTitle output line

# Final output line
print $HTMLTime.";".$url.";".$HTMLTitle.";".$HTMLText."\n";






$tree->delete;
# $tree->dump;

# https://api.twitter.com/1.1/search/tweets.json?q=%23freebandnames&since_id=24012619984051000&max_id=250126199840518145&result_type=mixed&count=4

# https://api.twitter.com/1.1/statuses/show.json?id=250036062792085504

# <a class="tweet-timestamp js-permalink js-nav" href="/oslopolitiops/status/250036062792085504" title="5:56 PM - 23 sep 12"><span class="_timestamp js-short-timestamp js-relative-timestamp" data-long-form="true" data-time="1348448217">8t</span></a>

# <p class="js-tweet-text">
#                  Nå er hestene igjen løse ved Gaustad. Denne gangen forsøker vi å bruke politiets sperrebånd, vi tror nemlig hestene vil respektere det.
#</p>
