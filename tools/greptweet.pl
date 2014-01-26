#!/usr/bin/perl
# 20120927/JT
# Author: oslopolitimoro <konakt@oslopolitimoro.org>
# Greps the tweet content from Twitter tweet and outputs
# a csv line.
#
# Requires HTML::Treebuilder, LWP::UserAgent
#
# Syntax:
#	perl greptweet.pl <url>
# Example:
#	perl greptweet.pl http://twitter.com/oslopolitiops/statuses/250036062792085504
# Output:
#	2012-09-23 17:56;http://twitter.com/oslopolitiops/statuses/250036062792085504;Nå er hestene igjen løse ...;Nå er hestene igjen løse ved Gaustad. Denne gangen forsøker vi å bruke politiets sperrebånd, vi tror nemlig hestene vil respektere det.
#
# This is used to create a CSV files of of tweets serving as source for another scripts creating the markdown files for Octopress.
#
# Update: 20130219: Date matching syntax updated due to changes in the sourcecode of the Twitter webpage.
# Update: 20130517: Matching for Text/title failed due to changes in the sourcecode of the Twitter webpage.
# Update: 20130528: Changed Regex for matching metadata. Failed because they've changed it again.
# Update: 20140126: Changed Regex for matching metadata. Failed because they(TM) changed it again.
#           Fixed the problem with quotes in tweets.
# ------------------------------------------------------------------------
use v5.10.1;

use strict;
use warnings;
use utf8;
use LWP::UserAgent;
use HTML::TreeBuilder;

die usage() unless @ARGV;

# Get HTML Tweet from TWitter
my $ua = new LWP::UserAgent;
$ua->timeout(120);
my $url         = $ARGV[0];

# Replace the mobile links, they use a different layout.
$url =~ s/mobile\.twitter\.com/www.twitter.com/i;

my $request     = new HTTP::Request( 'GET', $url );
my $response    = $ua->request($request);
my $HTMLcontent = $response->content();

# Parse HTMLcontent
my $tree = HTML::TreeBuilder->new_from_content($HTMLcontent);
$tree->parse($HTMLcontent);
$tree->eof();

my $title           = $tree->look_down( '_tag',  'title' );                                  # Get Tweet Title
my $searchtext      = $tree->look_down( '_tag', 'p', 'class', 'js-tweet-text tweet-text' );  # Get Tweet Text
my $tweettimestamp  = $tree->look_down( "class", "metadata");                                # Get Tweet Timestamp

# Get and format title (without the stupid "Twitter / <account>: "-stuff), we don't want that
my $HTMLTitle   = $title->as_text();
$HTMLTitle      =~ s/^[^\:]+\:\s//i;
$HTMLTitle      =~ s/\;/\&#59;/i;

# Get and format the text without leading spaces
my $HTMLText    = $searchtext->as_text();
$HTMLText       =~ s/^\s+//i;
$HTMLText       =~ s/;/\&#59;/i;
$HTMLText       =~ s/\"/&#34;/g;

# Grep and format the Tweet timestamp.
#my $HTMLTime = $tweettimestamp->as_HTML();
my $HTMLTime    = $tweettimestamp->as_text();

# Match date format: ' 07.14 - 24. jan. 2014 '
$HTMLTime       =~ m/\s+(?<hour>\d{1,2})(\:|\.)(?<minute>\d{1,2})\s\-\s(?<day>\d{1,2})\.\s(?<month>[a-z]{3})\.\s(?<year>\d{4})\s+/i;
# Other format with meridiem
# $HTMLTime       =~ m/\s+(?<hour>\d{1,2})(\:|\.)(?<minute>\d{1,2})\s(?<meridiem>\w{2})\s(\W)+(?<day>\d{1,2})\.\s(?<month>\w{3})\s(?<year>\d{2})\s+/i;

my $tweethour   = $+{hour};
my $tweetminute = $+{minute};
my $tweetday    = $+{day};
my $tweetmonth  = $+{month};
my $tweetyear   = $+{year};
my $meridiem    = '';
# my $meridiem    = $+{meridiem};  # Disabled until they(TM) switch it on again.

my %mon2num     = qw(
  jan 1  feb 2  mar 3  apr 4  mai 5  jun 6
  jul 7  aug 8  sep 9  okt 10 nov 11 des 12
);
$tweetmonth = $mon2num{"$tweetmonth"};

if ( $meridiem eq 'PM' ) { $tweethour += 12; }
if ( $tweethour == '24') { $tweethour = '00' }
if ( length($tweetmonth) eq 1 ) { $tweetmonth = "0" . $tweetmonth; }
if ( length($tweetday)   eq 1 ) { $tweetday   = "0" . $tweetday }
$HTMLTime =
    $tweetyear . "-"
  . $tweetmonth . "-"
  . $tweetday . " "
  . $tweethour . ":"
  . $tweetminute;

# Final output line
print "\""
  . $HTMLTime . "\",\""
  . $url . "\",\""
  . $HTMLTitle . "\",\""
  . $HTMLText . "\"\n";

# Cleanup
$tree->delete;

sub usage { "Syntax:\n $0 Tweet-url\n" }

# Some Syntax Reference
## Test-tweet
## http://twitter.com/oslopolitiops/statuses/250036062792085504
##
## Tag with timestamp of the tweet in HTML
## <a class="tweet-timestamp js-permalink js-nav" href="/oslopolitiops/status/250036062792085504" title="5:56 PM - 23 sep 12"><span class="_timestamp js-short-timestamp js-relative-timestamp" data-long-form="true" data-time="1348448217">8t</span></a>
##
## Tag with text of the Test-Tweet in HTML
## <p class="js-tweet-text">
##                  Nå er hestene igjen løse ved Gaustad. Denne gangen forsøker vi å bruke politiets sperrebånd, vi tror nemlig hestene vil respektere det.
##</p>
