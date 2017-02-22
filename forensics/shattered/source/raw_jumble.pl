#!/usr/bin/perl

use strict;
use warnings;

use Net::RawIP;

my $SIP = '4.5.6.7';
my $SPORT = 12345;
my $DIP = '8.9.10.11';
my $DPORT = 67891;

my $MTU = 1400;

unless ((defined $ARGV[0]) && ($ARGV[0] =~ m/^\d+$/)) {
    die 'Please specify base seq as first parameter.', "\n";
}
my $BASE_SEQ = $ARGV[0];

unless ((defined $ARGV[1]) && (-e $ARGV[1])) {
    die 'Please specify file as second parameter.', "\n";
}

my $file;
open (IN, $ARGV[1]) or die 'Unable to open file: ', $!, "\n";
{
    local $/ = undef;
    $file  = <IN>;
}
close IN;

my $FILELEN = length $file;

#my $FILELEN = 4000;
#$file = '0123456789' x 400;


while (1) {

    my $thisseq = int((rand() * ($FILELEN + $MTU)) - ($MTU));
    my $thislen = int((rand() * ($MTU - 1)) + 1);

    if ($thisseq < 0) {
	$thisseq = 0;
    }

    if ($thisseq + $thislen >= $FILELEN) {
	$thisseq -= (($thisseq + $thislen) - $FILELEN);
    }

    raw_send($SIP, $SPORT, $DIP, $DPORT, $BASE_SEQ, $thisseq,
	     substr($file, $thisseq, $thislen));

    select(undef, undef, undef, 0.1);
}


sub raw_send {
    my ($src_ip, $src_port, $dst_ip, $dst_port, $base_seq, $seq, $data) = @_;

    my $packet = new Net::RawIP;

    $packet->set({'ip'=>{'saddr' => $src_ip,
			 'daddr' => $dst_ip},
		  'tcp'=>{'source'=>$src_port,
			  'dest'=>$dst_port,
			  'ack'=>1,
			  'syn'=>0,
			  'seq'=>($base_seq + $seq) & 0xFFFFFFFF,
			  'ack_seq'=>1,
			  'data'=>$data}
		 });

    $packet->send(0,1);
}


