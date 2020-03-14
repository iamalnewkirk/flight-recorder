# NAME

FlightRecorder

# ABSTRACT

Logging for Distributed Systems

# SYNOPSIS

    package main;

    use FlightRecorder;

    my $f = FlightRecorder->new;

    # $f->begin('try');
    # $f->debug('something happend');
    # $f->end;

# DESCRIPTION

This package provides a simple mechanism for logging events with context,
serializing and distributing the event logs, and producing a transcript of
activity to provide insight into the behavior of distributed systems.

# INTEGRATES

This package integrates behaviors from:

[Data::Object::Role::Pluggable](https://metacpan.org/pod/Data%3A%3AObject%3A%3ARole%3A%3APluggable)

[Data::Object::Role::Throwable](https://metacpan.org/pod/Data%3A%3AObject%3A%3ARole%3A%3AThrowable)

# LIBRARIES

This package uses type constraints from:

[Types::Standard](https://metacpan.org/pod/Types%3A%3AStandard)

# ATTRIBUTES

This package has the following attributes:

## format

    format(Str)

This attribute is read-write, accepts `(Str)` values, and is optional.

## head

    head(Str)

This attribute is read-write, accepts `(Str)` values, and is optional.

## item

    item(HashRef)

This attribute is read-only, accepts `(HashRef)` values, and is optional.

## level

    level(Enum[qw(debug info warn error fatal)])

This attribute is read-only, accepts `(Enum[qw(debug info warn error fatal)])` values, and is optional.

## logs

    logs(ArrayRef[HashRef])

This attribute is read-only, accepts `(ArrayRef[HashRef])` values, and is optional.

## refs

    refs(HashRef)

This attribute is read-only, accepts `(HashRef)` values, and is optional.

# METHODS

This package implements the following methods:

## begin

    begin(Str $label) : Object

The begin method creates and logs a new context.

- begin example #1

        # given: synopsis

        $f->begin('test')

## branch

    branch(Str $label) : Object

The branch method creates and returns a new [FlightRecorder](https://metacpan.org/pod/FlightRecorder) object which
shares the event log with the parent object. This method creates a new context
when called.

- branch example #1

        # given: synopsis

        $f->begin('test')->branch('next')

## data

    data(HashRef[Str] $data) : Object

The data method associates arbitrary metadata with the last event.

- data example #1

        # given: synopsis

        $f->debug('something happened')->data({
          error => 'unknown at ./example line 10'
        });

## debug

    debug(Str @message) : Object

The debug method logs a `debug` level event with context.

- debug example #1

        # given: synopsis

        $f->debug('something happened')

## end

    end() : Object

The end method logs the end of the current context.

- end example #1

        # given: synopsis

        $f->begin('main')->end

## error

    error(Str @message) : Object

The error method logs an `error` level event with context.

- error example #1

        # given: synopsis

        $f->error('something happened')

## fatal

    fatal(Str @message) : Object

The fatal method logs a `fatal` level event with context.

- fatal example #1

        # given: synopsis

        $f->fatal('something happened')

## info

    info(Str @message) : Object

The info method logs an `info` level event with context.

- info example #1

        # given: synopsis

        $f->info('something happened')

## output

    output(FileHandle $handle) : Str

The output method outputs the last event using the format defined in the
`format` attribute.

- output example #1

        # given: synopsis

        $f->begin('test')->output

## report

    report(Str $name, Str $level) : Object

The report method loads and returns the specified report plugin.

- report example #1

        # given: synopsis

        $f->report('verbose')

- report example #2

        # given: synopsis

        $f->report('succinct', 'fatal')

## serialize

    serialize() : HashRef

The serialize method normalizes and serializes the event log and returns it as
a `hashref`.

- serialize example #1

        # given: synopsis

        $f->begin('main')->serialize

## succinct

    succinct() : Object

The succinct method loads and returns the [FlightRecorder::Plugin::Succinct](https://metacpan.org/pod/FlightRecorder%3A%3APlugin%3A%3ASuccinct)
report plugin.

- succinct example #1

        # given: synopsis

        $f->succinct

## switch

    switch(Str $name) : Object

The switch method finds and sets the current context based on the name
provided.

- switch example #1

        # given: synopsis

        $f->begin('main')->begin('test')->switch('main')

## verbose

    verbose() : Object

The verbose method loads and returns the [FlightRecorder::Plugin::Verbose](https://metacpan.org/pod/FlightRecorder%3A%3APlugin%3A%3AVerbose)
report plugin.

- verbose example #1

        # given: synopsis

        $f->verbose

## warn

    warn(Str @message) : Object

The warn method logs a `warn` level event with context.

- warn example #1

        # given: synopsis

        $f->warn('something happened')

# AUTHOR

Al Newkirk, `awncorp@cpan.org`

# LICENSE

Copyright (C) 2011-2019, Al Newkirk, et al.

This is free software; you can redistribute it and/or modify it under the terms
of the The Apache License, Version 2.0, as elucidated in the ["license
file"](https://github.com/iamalnewkirk/flight-recorder/blob/master/LICENSE).

# PROJECT

[Wiki](https://github.com/iamalnewkirk/flight-recorder/wiki)

[Project](https://github.com/iamalnewkirk/flight-recorder)

[Initiatives](https://github.com/iamalnewkirk/flight-recorder/projects)

[Milestones](https://github.com/iamalnewkirk/flight-recorder/milestones)

[Contributing](https://github.com/iamalnewkirk/flight-recorder/blob/master/CONTRIBUTE.md)

[Issues](https://github.com/iamalnewkirk/flight-recorder/issues)
