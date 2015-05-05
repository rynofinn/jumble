#!/usr/bin/perl -l
use strict;
use warnings;
use List::Util qw/shuffle/;

my $startword = shift;
my @result;
my $DEBUG = 0;
my $word;

print "finding all permutations for $startword:\n";

my @sorted = sort split('',$startword);
permute(join("",@sorted));
exit;

# solve for 2 characters
#

sub permute {
  my $list = shift;
  my @result;
  my $temp;
  my $k;
  my $l;
  my @letters;
  my $kval;
  my $lval;
  my @revlast;

  print "permute got input of $list\n";

  @letters = sort split('', $list);
  if (checkword(\@letters)) {
    print "a word: ",@letters,"\n";
  }
  #print "letters array has ",@letters, "\n" if $DEBUG;
  $k = findk(\@letters);
  $l = findl($k, \@letters);
  while ($k > -1) {
    $kval = $letters[$k];
    $lval = $letters[$l];
    print "k=$k, l=$l\n" if $DEBUG;
    print "swapping...\n" if $DEBUG;
    $letters[$k] = $lval; $letters[$l] = $kval;
    print "after swap, list is ",@letters,"\n" if $DEBUG;
    # reverse elements after kindex
    # split list after kindex
    my @first = @letters[0 .. ${k}];
    my @last = @letters[${k}+1 .. scalar(@letters) - 1];
    print "split into @first and @last\n" if $DEBUG;
    # reverse the second portion
    @revlast = reverse(@last);
    print "reversing second portion... ", @revlast,"\n" if $DEBUG;
    @letters = (@first, @revlast);
    print "next sequence: ",@letters if $DEBUG;
    if (checkword(\@letters)) {
      print "a word: ",@letters,"\n";
    }
    # find new k,l
    $k = findk(\@letters);
    $l = findl($k, \@letters);
  }
}

sub findk {
  my $aref = shift;
  my @a = @{$aref};
  my $result = -1;
  my $end = scalar(@a) - 1;
  my $i;

  #print "findk got array: ",@a, "\n" if $DEBUG;
  #print "end is $end\n" if $DEBUG;

  for ($i=0; $i < $end; $i++) {
    #print "comparing ",$a[$i], " and ", $a[$i+1], "\n" if $DEBUG;
    if ($a[$i] lt $a[$i+1]) {
      if ($i > $result) {
        $result = $i;
      }
    }
  }
  return $result;
}


sub findl {
  my $k = shift;
  my $aref = shift;
  my @a = @{$aref};
  my $result = 0;

  for (my $i=$k; $i<scalar(@a); $i++) {
    if ($a[$k] lt $a[$i]) {
      if ($i > $result) {
        $result = $i;
      }
    }
  }
  return $result;
}

sub checkword {
  my $aref = shift;
  my @in = @{$aref};
  my $in = join('',@in);
  my $result;
  my $isword = 0;

  #print "checking for word: $in...";
  $result = `echo $in | aspell -a`;
  $result =~ s/^.*International Ispell Version.*$//m;
  #print "got result $result\n";
  if ($result =~ m/\*/) {
    $isword = 1;
  }
  return $isword;
}
