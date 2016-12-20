#! /usr/bin/perl
# plot file ... - a command line interface for gnuplot
# (c) R.G. Della Valle 1996

if( $#ARGV<0 ){
  print "plot      a command line interface for gnuplot\n\n";
  print "Usage:    plot item ...\n\n";
  print "Item:     -pPrinter     print (default: postscript)\n";
  print "          -tTime        set the visualization time\n";
  print "          'X,Y,...'     set title for X, Y, plot\n";
  print "          min:max       set range for X, then Y\n";
  print "          File          read X,Y data from File\n";
  print "          x,y           plot column y vs column x\n";
  print "          y             plot column y vs column 1\n";
  print "          x,y1,y2,...   plot y1 vs x, y2 vs x, ...\n\n";
  print "Ranges of contiguous columns are represented as i-j.\n";
  print "Column 0 stays for the number 0,1,2... of the data.\n";
  print "Points are used for all columns by default. Lines or\n";
  print "lines+points are specified by - or + signs in front\n";
  print "of x (for all columns) or y (for that column only).\n";
  print "Printer, title, X range and Y range must appear in\n";
  print "the given order. Files and columns may be repeated.\n";
  print "Files to be plotted accumulate and remain in effect\n";
  print "for all sets of columns immediately following them.\n";
  print "Unless redirected, plot's output is piped to gnuplot.\n";
  exit;
}

#  Variables:
# $hardcopy  a valid gnuplot's set term for printing
# @f, $f     list of files to be plotted, current file
# @c, $c     list of column to be plotted, current column
# $DefStyle  default style (for all columns)
# $ColStyle  style for the current column only
# $comma     used to format the output, is "" or ","
# @l         used to split the list of columns

# If output is to a tyy then pipe all output through gnuplot
if( -t STDOUT ){ open( STDOUT, "| gnuplot" ) }

$coltitleflag='down';
if( $ARGV[0] eq "-col" ){
  shift;
  $coltitleflag='up';
}

# Argument starts with -p, get printer name (default PostScript, 18pt font)
if( $ARGV[0] =~ /^[+-][ph](.*)/i ){
  shift;
  $hardcopy = ( $1 ? $1 : "png notransparent nointerlace truecolor");
#  $hardcopy = ( $1 ? $1 : "postscript enhanced color solid");
}

# Argument starts with -t, set visualization time (default 120)
if( $ARGV[0] =~ /^[+-][t](.*)/i ){
  shift;
  $time = ( $1 ? $1 : 120 );
}

# If the first argument cannot be anything else, assume it is for titles
if( $ARGV[0] =~ /[,:;`'"?!@#&%* (){}<>|^]/ &&
    $ARGV[0] =~ /[^,:0-9.e+-]/i            &&
    $ARGV[0] =~ /^([^,]*),?([^,]*),?(.*)$/ ){
  shift;
  print "set xlabel '$1'\n";
  print "set ylabel '$2'\n";
  print "set title  '$3'\n";
}

# This is the main "plot" statement for gnuplot
print "plot ";

# The next two arguments migth be x and y ranges
if( $ARGV[0] =~ /^[0-9.e+-]*:[0-9.e+-]*$/i ){ print "[", shift, "] " }
if( $ARGV[0] =~ /^[0-9.e+-]*:[0-9.e+-]*$/i ){ print "[", shift, "] " }

# Main loop: all other arguments specify either columns or files
while ( $_ = shift ) {
  if( /^[+-]?[0-9][0-9,+-]*$/ ){ &cols() }
  else                         { &file() }
}
&flush();

# Make hardcopy (default PostScript, 18pt font) or pause (default 30 seconds)
if( $hardcopy ){
  print "\nset term $hardcopy\n";
  print "set out 'hardcopy.png'\n";
  print "replot\n";
#  print "!/usr/bin/print hardcopy.ps\n";
} else {
  printf "\npause %d\n", ( $time ? $time : 15 );
}

#----------------------------------------------------------------------------
# style(default) - return "lines" or "linespoints" if $_ starts in "-" or "+"
sub style {
  if( s/^\-//    ){ return "lines" }
#  elsif( s/^\+// ){ return "linespoints" }
  elsif( s/^\+// ){ return "dots" }
#  elsif( s/^\.// ){ return "dots" }
  else            { return shift( @_ ) }
}

# cols() - add all column pairs and styles in $_ to @c column list
sub cols {
  $DefStyle = &style("points");			 # Get default style
  s/^([1-9][0-9]*)$/1,$1/;                       # Turn y into 1,y
  while( s/(\d+)-(\d+)/join(',',($1..$2))/e ){}; # Expand i-j ranges
  @l = split(',+',$_);                           # Split at commas
  foreach $_ ( @l[1..$#l] ){                     # Loop on columns
    $ColStyle = &style($DefStyle);               # Get column style
    push( @c, "$l[0]:$_ with $ColStyle" );       # Add x,y to @c
  }
}

# file() - add file $_ to @f file list, flush @c and @l lists if both exist
sub file {
  if( @f && @c ){ &flush() }
  push( @f, $_ );
}

# flush() - plot all accumulated column pairs and files, and flush both lists
sub flush {
  if( ! @c ){ push( @c, "1:2 with points" ) }	 # Default column pair
  foreach $f ( @f ){				 # For all files
    foreach $c ( @c ){				 # For all column pairs
      $c =~ /^([0-9]+:)([0-9]+)(.*)/; 		 # Title is 'file i:j' for
      if( "$f $1" ne $l ){ $x = $l = "$f $1" }	 # new file or new i ...
      else               { $x =      ""      }	 # 'j' only otherwise 
      $t = "using $1$2 title '$x$2'$3";	 	 # columns title style
      if( $coltitleflag eq "up" ){
	$t = "using $1$2 title column(1) $3";
      }
      print "$comma \\\n '$f' $t";	 	 # file columns title style
      $comma = ",";				 # Use "," after first plot
    }
  }
  undef @f;
  undef @c;
}

