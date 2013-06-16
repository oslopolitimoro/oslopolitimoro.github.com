package streetmatch;
# 20130518/JT
# Author: oslopolitimoro <konakt@oslopolitimoro.org>
# Script tries to match streetnames from the tweet with the streetlists
# And links them against OSM/Google Maps if possible.
#
# Requires Exporter File::Slurp URI::Escape Encode  
#
# Example:
#   my @streetnames = streetmatch::grepstreetnames (@streetfiles);
#    my $htmlmap = streetmatch::matchString2Street (@streetnames,$text);
# Output:
#   hash:
#     iframe => html map
#     link   => <a href="">street name</a>
#     name   => street name
#
# 20130716  Fixed encoding issue which prevented street names with special characters to be identified.
# ------------------------------------------------------------------------
use strict;
use warnings;
use Exporter;
use utf8;
use File::Slurp;
use URI::Escape;
use Encode;
use vars qw($VERSION @ISA @EXPORT @EXPORT_OK %EXPORT_TAGS);

$VERSION        = 1.00;
@ISA            = qw(Exporter);
@EXPORT         = ();
@EXPORT_OK      = qw(greepstreetnames matchString2Street);
%EXPORT_TAGS    = ( DEFAULT => [qw(&greepstreetnames &matchString2Street)] );

# Parameters
#my $searchstring = encode('utf8','Kirkegårdsgata: Bunadskledd kvinne ble truffet av egg, kastet fra en leilighet. En angrende synder påtar seg å betale utgifter til rens.');
#my @streetfiles = ('street.1.txt','street.2.txt');

#my @streetnames = &grepstreetnames (@streetfiles);
#my $htmlmap = &matchString2Street (@streetnames,$searchstring);

#say $htmlmap;

# Routine for matching a string to the street names
# Possible fields_
# 
# iframe
# links
# name
sub matchString2Street {
    my @streetnames = @_;
    my ($street, $street_orig);
    my $searchstring = pop(@streetnames);
    my %htmlcode = (
        'iframe'    => '',
        'link'      => '',
        'name'      => '',
    );

    # Clean searchstring
    $searchstring =~ s/[\.\-\?\:\s]+//ig;
    
    foreach (@streetnames) {
        chomp($_);
        $street = $_;
        $street_orig = $_;
        $street =~ s/[\s\"]+//g;

        # Streetname is an alias assigment if an '=' is in there:
        #   Replace the street name with the assignment in order to get a hit
        if ($street =~ m/\=/ ){
            my @assignment = split(/=/,$street);
            $street = $assignment[1];
            #$street =~ s/.*\=(.)*/$+/gi;
            
            # Continue here
        }

        if ( $searchstring =~ m/\Q${street}\E/i ) {            
            $htmlcode{iframe} = encode('utf8',"<div style=\"float:right; margin:5px; position:relative;top:-130px;\"><iframe width=\"150\" height=\"150\" frameborder=\"0\" scrolling=\"no\" marginheight=\"0\" marginwidth=\"0\" src=\"http://maps.google.com/maps?q=".uri_escape($_).",+Oslo&hl=no&t=m&z=14&output=embed&iwloc=&\"></iframe><br/><small><a href=\"http://maps.google.com/maps?q=".uri_escape($_).",+Oslo&hl=no&t=m&z=14&source=embed&iwloc=A\" style=\"color:#0000FF;text-align:left\" target=\"_new\">Vis st&oslash;rre kart</a></small></div>");
            $htmlcode{link} = "<a href=\"https://maps.google.com/maps?q=".uri_escape($_).",+Oslo&hl=no&t=m&z=14&source=embed&iwloc=A\" style=\"color:#0000FF;text-align:left\" target=\"_new\">".$_."</a>";
            $htmlcode{name} = encode('utf8',$street_orig);
        }
    }
    return %htmlcode;
}

# Subroutine reads all streetnames from the files
#    and returns them as array.
sub grepstreetnames {
    my @streetnames = $_[1];
    my @streetfiles = ('street.1.txt','street.2.txt');
     foreach (@streetfiles) {
         # Read the file into the streetnames-array
        my @lines = read_file($_, binmode => ':utf8');
        @streetnames = (@streetnames, @lines);
     }
    return @streetnames;
}
# Always return a tre value from the module.
1;