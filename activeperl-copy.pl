#---------------------------------------------------------------------
# $Header: /Perl/OlleDB/activeperl-copy.pl 4     05-11-13 17:22 Sommar $
#
# A simple script for installing a binary of OlleDB under ActivePerl 809 and up.
#
# $History: activeperl-copy.pl $
# 
# *****************  Version 4  *****************
# User: Sommar       Date: 05-11-13   Time: 17:22
# Updated in $/Perl/OlleDB
#
# *****************  Version 3  *****************
# User: Sommar       Date: 05-11-13   Time: 16:51
# Updated in $/Perl/OlleDB
#
# *****************  Version 2  *****************
# User: Sommar       Date: 05-11-13   Time: 16:32
# Updated in $/Perl/OlleDB
#
# *****************  Version 1  *****************
# User: Sommar       Date: 05-11-12   Time: 21:55
# Created in $/Perl/OlleDB
#---------------------------------------------------------------------

use strict;
use File::Copy;

sub makedir {
    my($dir) = @_;
    mkdir $dir, 0755;
    if (not -d $dir) {
       die "Failed to create '$dir': $!\n";
    }
}

sub do_copy{
   my($src, $dest) = @_;
   if (-e $dest) {
      system(qq!attrib -r "$dest"!);
      unlink($dest);
   }
   print "Copying $src to $dest\n";
   copy($src, $dest) or die "Could not copy $src: $!\n";
   system(qq!attrib +r "$dest"!);
}

my $perltop = shift(@ARGV);
if (not $perltop) {
   $perltop = $^X;
   if ($perltop =~ /\\/) {
      my @perltop = split(/\\/, $perltop);
      pop(@perltop);
      pop(@perltop);
      $perltop = join('\\', @perltop);
   }
   else {
      my @PATH = split(/;/, $ENV{'PATH'});
      my $progname = $perltop;
      $progname = "$progname.EXE" unless $progname =~ /.exe$/i;
      undef $perltop;
      while (@PATH) {
         if (-e "$PATH[0]\\$progname") {
            $perltop = $PATH[0];
            my @perltop = split(/\\/, $perltop);
            pop(@perltop);
            $perltop = join('\\', @perltop);
            last;
         }
         shift @PATH;
      }
   }
}

my $ver = substr($], 0, 5);

if (not (grep ($_ == $ver, (5.008)))) {
   print "You have Perl version $ver, but this install kit includes only binaries\n";
   print "for ActivePerl 8xx (Perl 5.8).\n";
   print "You will need to install from sources. See README.html.\n";
   exit 245;
}


print "Installing MSSQL::OlleDB modules in $perltop\n";

my $libdir  = "$perltop\\site\\lib\\MSSQL";
my $htmldir = "$perltop\\html\\site\\lib\\MSSQL";
my $autodir = "$perltop\\site\\lib\\auto\\MSSQL";
makedir($libdir);
makedir($htmldir);
makedir($autodir);
makedir("$autodir\\OlleDB");

do_copy("blib\\arch\\auto\\MSSQL\\OlleDB\\OlleDB-$ver.dll",
        "$autodir\\OlleDB\\OlleDB.dll");
do_copy("msvcr70.dll", "$autodir\\OlleDB\\msvcr70.dll");

do_copy('OlleDB.pm', "$libdir\\OlleDB.pm");

do_copy('mssql-olledb.html', "$htmldir\\OlleDB.html");

