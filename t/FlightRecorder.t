use 5.014;

use strict;
use warnings;
use routines;

use Test::Auto;
use Test::More;
use Test::Trap;

=name

FlightRecorder

=cut

=tagline

Structured Logging

=cut

=abstract

Logging for Distributed Systems

=cut

=includes

method: begin
method: branch
method: count
method: data
method: debug
method: end
method: error
method: fatal
method: info
method: output
method: report
method: reset
method: serialize
method: simple
method: succinct
method: switch
method: verbose
method: warn

=cut

=synopsis

  package main;

  use FlightRecorder;

  my $f = FlightRecorder->new(
    auto => undef
  );

  # $f->begin('try');
  # $f->debug('something happened');
  # $f->end;

=cut

=libraries

Types::Standard

=cut

=attributes

auto: ro, opt, Maybe[FileHandle]
head: ro, opt, Str
item: ro, opt, HashRef
refs: ro, opt, HashRef
level: ro, opt, Enum[qw(debug info warn error fatal)]
logs: ro, opt, ArrayRef[HashRef]
format: rw, opt, Str

=cut

=integrates

Data::Object::Role::Pluggable
Data::Object::Role::Throwable

=cut

=description

This package provides a simple mechanism for logging events with context,
serializing and distributing the event logs, and producing a transcript of
activity to provide insight into the behavior of distributed systems.

=cut

=method begin

The begin method creates and logs a new context.

=signature begin

begin(Str $label) : Object

=example-1 begin

  # given: synopsis

  $f->begin('test')

=cut

=method branch

The branch method creates and returns a new L<FlightRecorder> object which
shares the event log with the parent object. This method creates a new context
when called.

=signature branch

branch(Str $label) : Object

=example-1 branch

  # given: synopsis

  $f->begin('test')->branch('next')

=cut

=method count

The count method returns the total number of log entries, or the number of log
entries matching the log level specified.

=signature count

count(Maybe[Str] $level) : Int

=example-1 count

  # given: synopsis

  $f->begin('try')->debug('something happened')->end;
  $f->count;

=example-2 count

  # given: synopsis

  $f->info('something happened');
  $f->count('info');

=example-3 count

  # given: synopsis

  $f->fatal('something happened');
  $f->count('fatal');

=cut

=method data

The data method associates arbitrary metadata with the last event.

=signature data

data(HashRef[Str] $data) : Object

=example-1 data

  # given: synopsis

  $f->debug('something happened')->data({
    error => 'unknown at ./example line 10'
  });

=cut

=method debug

The debug method logs a C<debug> level event with context.

=signature debug

debug(Str @message) : Object

=example-1 debug

  # given: synopsis

  $f->debug('something happened')

=cut

=method end

The end method logs the end of the current context.

=signature end

end() : Object

=example-1 end

  # given: synopsis

  $f->begin('main')->end

=cut

=method error

The error method logs an C<error> level event with context.

=signature error

error(Str @message) : Object

=example-1 error

  # given: synopsis

  $f->error('something happened')

=cut

=method fatal

The fatal method logs a C<fatal> level event with context.

=signature fatal

fatal(Str @message) : Object

=example-1 fatal

  # given: synopsis

  $f->fatal('something happened')

=cut

=method info

The info method logs an C<info> level event with context.

=signature info

info(Str @message) : Object

=example-1 info

  # given: synopsis

  $f->info('something happened')

=cut

=method output

The output method outputs the last event using the format defined in the
C<format> attribute. This method is called automatically after each log-event
if the C<auto> attribute is set, which is by default set to C<STDOUT>.

=signature output

output(FileHandle $handle) : Str

=example-1 output

  # given: synopsis

  $f->begin('test')->output

=example-2 output

  package main;

  use FlightRecorder;

  my $f = FlightRecorder->new;

  $f->begin('try');

  # $f->output

  $f->debug('something happened');

  # $f->output

  $f->end;

  # $f->output

=cut

=method report

The report method loads and returns the specified report plugin.

=signature report

report(Str $name, Str $level) : Object

=example-1 report

  # given: synopsis

  $f->report('verbose')

=example-2 report

  # given: synopsis

  $f->report('succinct', 'fatal')

=cut

=method reset

The reset method returns an object to its initial state.

=signature reset

reset() : Object

=example-1 reset

  # given: synopsis

  $f->begin('try')->debug('something happened')->end;
  $f->reset;

=example-2 reset

  # given: synopsis

  $f->begin('try')->debug('something happened')->end;
  $f->branch('main')->switch('try')->fatal('something happened')->end;
  $f->reset;

=cut

=method serialize

The serialize method normalizes and serializes the event log and returns it as
a C<hashref>.

=signature serialize

serialize() : HashRef

=example-1 serialize

  # given: synopsis

  $f->begin('main')->serialize

=cut

=method simple

The simple method loads and returns the
L<FlightRecorder::Plugin::ReportSimple> report plugin.

=signature simple

simple() : Object

=example-1 simple

  # given: synopsis

  $f->simple

=cut

=method succinct

The succinct method loads and returns the
L<FlightRecorder::Plugin::ReportSuccinct> report plugin.

=signature succinct

succinct() : Object

=example-1 succinct

  # given: synopsis

  $f->succinct

=cut

=method switch

The switch method finds and sets the current context based on the name
provided.

=signature switch

switch(Str $name) : Object

=example-1 switch

  # given: synopsis

  $f->begin('main')->begin('test')->switch('main')

=cut

=method verbose

The verbose method loads and returns the
L<FlightRecorder::Plugin::ReportVerbose> report plugin.

=signature verbose

verbose() : Object

=example-1 verbose

  # given: synopsis

  $f->verbose

=cut

=method warn

The warn method logs a C<warn> level event with context.

=signature warn

warn(Str @message) : Object

=example-1 warn

  # given: synopsis

  $f->warn('something happened')

=cut

package main;

my $test = testauto(__FILE__);

my $subs = $test->standard;

$subs->synopsis(fun($tryable) {
  ok my $result = $tryable->result;
  ok $result->isa('FlightRecorder');

  $result
});

$subs->example(-1, 'begin', 'method', fun($tryable) {
  ok my $result = $tryable->result;
  is scalar(@{$result->logs}), 1;
  is $result->head, '0001';
  is $result->refs->{'0001'}, 'test';
  is $result->logs->[0]{message}, 'test began';

  $result
});

$subs->example(-1, 'branch', 'method', fun($tryable) {
  ok my $result = $tryable->result;
  is scalar(@{$result->logs}), 2;
  is $result->head, '0002';
  is $result->refs->{'0001'}, 'test';
  is $result->refs->{'0002'}, 'next';
  is $result->logs->[0]{message}, 'test began';
  is $result->logs->[1]{message}, 'next began';

  $result
});

$subs->example(-1, 'count', 'method', fun($tryable) {
  ok my $result = $tryable->result;
  is $result, 3;

  $result
});

$subs->example(-2, 'count', 'method', fun($tryable) {
  ok my $result = $tryable->result;
  is $result, 1;

  $result
});

$subs->example(-3, 'count', 'method', fun($tryable) {
  ok my $result = $tryable->result;
  is $result, 1;

  $result
});

$subs->example(-1, 'data', 'method', fun($tryable) {
  ok my $result = $tryable->result;
  is scalar(@{$result->logs}), 2;
  is $result->head, '0001';
  is $result->refs->{'0001'}, 'main';
  is $result->logs->[0]{message}, 'main began';
  is $result->logs->[1]{message}, 'something happened';

  my $item = $result->logs->[1];
  my $data = $item->{data};

  is scalar(@{$data}), 1;
  is $data->[0]{error}, 'unknown at ./example line 10';

  $result
});

$subs->example(-1, 'debug', 'method', fun($tryable) {
  ok my $result = $tryable->result;
  is scalar(@{$result->logs}), 2;
  is $result->head, '0001';
  is $result->refs->{'0001'}, 'main';
  is $result->logs->[0]{message}, 'main began';
  is $result->logs->[1]{message}, 'something happened';
  is $result->logs->[1]{level}, 'debug';

  $result
});

$subs->example(-1, 'end', 'method', fun($tryable) {
  ok my $result = $tryable->result;
  is scalar(@{$result->logs}), 2;
  is $result->head, '0001';
  is $result->refs->{'0001'}, 'main';
  is $result->logs->[0]{message}, 'main began';
  is $result->logs->[1]{message}, 'main ended';
  is $result->logs->[1]{level}, 'debug';

  $result
});

$subs->example(-1, 'error', 'method', fun($tryable) {
  ok my $result = $tryable->result;
  is scalar(@{$result->logs}), 2;
  is $result->head, '0001';
  is $result->refs->{'0001'}, 'main';
  is $result->logs->[0]{message}, 'main began';
  is $result->logs->[1]{message}, 'something happened';
  is $result->logs->[1]{level}, 'error';

  $result
});

$subs->example(-1, 'fatal', 'method', fun($tryable) {
  ok my $result = $tryable->result;
  is scalar(@{$result->logs}), 2;
  is $result->head, '0001';
  is $result->refs->{'0001'}, 'main';
  is $result->logs->[0]{message}, 'main began';
  is $result->logs->[1]{message}, 'something happened';
  is $result->logs->[1]{level}, 'fatal';

  $result
});

$subs->example(-1, 'info', 'method', fun($tryable) {
  ok my $result = $tryable->result;
  is scalar(@{$result->logs}), 2;
  is $result->head, '0001';
  is $result->refs->{'0001'}, 'main';
  is $result->logs->[0]{message}, 'main began';
  is $result->logs->[1]{message}, 'something happened';
  is $result->logs->[1]{level}, 'info';

  $result
});

$subs->example(-1, 'output', 'method', fun($tryable) {
  ok my $result = trap { $tryable->result };
  like $trap->stdout, qr/\w+ \w+\s+\d+ [\d:]+ \d+ \[0001\] \@debug test began/;

  $result
});

$subs->example(-2, 'output', 'method', fun($tryable) {
  ok my $result = trap { $tryable->result };
  my $lines = [split /\n/, $trap->stdout];
  like $lines->[0], qr/\w+ \w+\s+\d+ [\d:]+ \d+ \[0001\] \@debug try began/;
  like $lines->[1], qr/\w+ \w+\s+\d+ [\d:]+ \d+ \[0001\] \@debug something happened/;
  like $lines->[2], qr/\w+ \w+\s+\d+ [\d:]+ \d+ \[0001\] \@debug try ended/;

  ''
});

$subs->example(-1, 'report', 'method', fun($tryable) {
  ok my $result = $tryable->result;
  ok $result->isa('FlightRecorder::Plugin::ReportVerbose');
  ok $result->isa('FlightRecorder::Plugin::Report');
  ok $result->flight_recorder;
  is $result->level, 'debug';

  $result
});

$subs->example(-2, 'report', 'method', fun($tryable) {
  ok my $result = $tryable->result;
  ok $result->isa('FlightRecorder::Plugin::ReportSuccinct');
  ok $result->isa('FlightRecorder::Plugin::Report');
  ok $result->flight_recorder;
  is $result->level, 'fatal';

  $result
});

$subs->example(-1, 'reset', 'method', fun($tryable) {
  ok my $result = $tryable->result;
  ok !exists $result->{head};
  ok !exists $result->{item};
  ok !exists $result->{refs};
  ok !exists $result->{logs};

  $result
});

$subs->example(-2, 'reset', 'method', fun($tryable) {
  ok my $result = $tryable->result;
  ok !exists $result->{head};
  ok !exists $result->{item};
  ok !exists $result->{refs};
  ok !exists $result->{logs};

  $result
});

$subs->example(-1, 'serialize', 'method', fun($tryable) {
  ok my $result = $tryable->result;
  ok $result->{head};
  ok $result->{level};
  ok $result->{logs};
  ok $result->{refs};
  ok $result->{zeros};

  ok !$result->{item};

  $result
});

$subs->example(-1, 'simple', 'method', fun($tryable) {
  ok my $result = $tryable->result;
  ok $result->isa('FlightRecorder::Plugin::ReportSimple');
  ok $result->isa('FlightRecorder::Plugin::Report');
  ok $result->flight_recorder;
  is $result->level, 'debug';

  $result
});

$subs->example(-1, 'succinct', 'method', fun($tryable) {
  ok my $result = $tryable->result;
  ok $result->isa('FlightRecorder::Plugin::ReportSuccinct');
  ok $result->isa('FlightRecorder::Plugin::Report');
  ok $result->flight_recorder;
  is $result->level, 'debug';

  $result
});

$subs->example(-1, 'switch', 'method', fun($tryable) {
  ok my $result = $tryable->result;
  is scalar(keys %{$result->refs}), 2;
  is $result->head, '0001';
  is $result->refs->{'0001'}, 'main';
  is $result->refs->{'0002'}, 'test';

  $result
});

$subs->example(-1, 'verbose', 'method', fun($tryable) {
  ok my $result = $tryable->result;
  ok $result->isa('FlightRecorder::Plugin::ReportVerbose');
  ok $result->isa('FlightRecorder::Plugin::Report');
  ok $result->flight_recorder;
  is $result->level, 'debug';

  $result
});

$subs->example(-1, 'warn', 'method', fun($tryable) {
  ok my $result = $tryable->result;
  is scalar(@{$result->logs}), 2;
  is $result->head, '0001';
  is $result->refs->{'0001'}, 'main';
  is $result->logs->[0]{message}, 'main began';
  is $result->logs->[1]{message}, 'something happened';
  is $result->logs->[1]{level}, 'warn';

  $result
});

ok 1 and done_testing;
