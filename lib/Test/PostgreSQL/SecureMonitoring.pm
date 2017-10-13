package Test::PostgreSQL::SecureMonitoring;

use strict;
use warnings;

=head1 NAME

 Test::PostgreSQL::SecureMonitoring - Test Class for PostgreSQL Secure Monitoring

 $Id: SecureMonitoring.pm 672 2017-04-26 22:58:00Z alvar $

=head1 VERSION

Version 0.1.0

=cut

use version; our $VERSION = qv("v0.1.0");

# Subroutine prototypes explicitely desired in Test::...-Modules!
## no critic (Subroutines::ProhibitSubroutinePrototypes Modules::ProhibitAutomaticExportation)


=head1 SYNOPSIS

=encoding utf8

  use Test::PostgreSQL::SecureMonitoring;
  
  my $result = result_ok($check);
  my $result = result_ok($check, $clustername);
  my $result = result_ok($check, $clustername, $message);
  
  warning_ok($result, $message);                 # message always optional
  no_warning_ok($result, $message);
  critical_ok($result, $message);
  no_critical_ok($result, $message);
  
  name_is($result, $name, $message);
  
  result_is($result, 1, $message);              # you can check the reasult value with this builtin test
  is($result->{result}, 1, $message);           # use Test::More!
  ok($result->{result} > 2, $message);          # you can check the result manually
  
  result_eq_or_diff($result, $data, $message);
  
  # more to be done when needed
  
  
  

=head1 DESCRIPTION


This Module is a helper module for Testing Posemo Checks.

It is NO Test::Builder(::Module)-Subclass and some test subs 
give more then one test result. 


=cut

use base qw(Exporter);
our @EXPORT = qw( result_ok no_warning_ok no_critical_ok name_is result_type_is row_type_is result_unit_is result_is result_cmp);


# use parent 'Test::Builder::Module';

use Test::More;
use Test::Exception;
use Data::Dumper;
use Test::PostgreSQL::Starter;

use PostgreSQL::SecureMonitoring;


=head2 result_ok( $check [, $clustername, $message] )

Returns the result object for check $check in the $clustername cluster.

=cut


sub result_ok($;$$)
   {
   my $checkname   = shift;
   my $clustername = shift;
   my $message     = shift // ( "Result for $checkname on cluster " . ( $clustername // "unnamed" ) );

   my $tps_conf = pg_read_conf_ok( $clustername, "Read conf (for $message)" );

   my $result;

   SKIP:
      {
      skip "Got no conf for $message", 3 unless $tps_conf;    ## no critic(ValuesAndExpressions::ProhibitMagicNumbers)

      my ( $app, $check );

      # Get Monitoring Obj
      lives_ok(
         sub {
            $app = PostgreSQL::SecureMonitoring->new(
                                                      database => "_posemo_tests",
                                                      user     => "_posemo_tests",
                                                      port     => $tps_conf->{port},
                                                    );
         },
         "Posemo Object (for $message)"
              );

      skip "Got no Object for $message", 2 unless $app;

      # Get Check Object
      lives_ok( sub { $check = $app->new_check($checkname) }, "Check Object (for $message)" );

      skip "Got no check object for $message", 1 unless $check;


      # get result from check
      lives_ok( sub { $result = $check->run_check }, "Run Check" );

      } ## end SKIP:

   ok( ref $result eq "HASH", "got Result for $message" ) or diag "Result is no hashref: " . Dumper($result);

   return $result;
   } ## end sub result_ok($;$$)



=head2 warning_ok( $result [, $message] )

Test passes, if there is a warning in the result

=cut


sub warning_ok($;$)
   {
   my $result = shift;
   my $message = shift // "Result has warning";
   return ok( $result->{warning}, $message );
   }


=head2 no_warning_ok( $result [, $message] )

Test passes, if there is no warning in the result

=cut


sub no_warning_ok($;$)
   {
   my $result = shift;
   my $message = shift // "Result has no warning";
   return ok( !$result->{warning}, $message );
   }


=head2 critical_ok( $result [, $message] )

Test passes, if result is critical.

=cut


sub critical_ok($;$)
   {
   my $result = shift;
   my $message = shift // "Result is critical";
   return ok( $result->{critical}, $message );
   }

=head2 no_critical_ok( $result [, $message] )

Test passes, if result is critical.

=cut


sub no_critical_ok($;$)
   {
   my $result = shift;
   my $message = shift // "Result is not crtitical";
   return ok( !$result->{critical}, $message );
   }


=head2 name_is($result, $name [, $message])

Checks if the name is the same as the result name.

=cut

sub name_is($$;$)
   {
   my $result  = shift;
   my $name    = shift;
   my $message = shift // "Check name is '$name'";

   return is( $result->{check_name}, $name, $message );
   }


=head2 result_type_is($result, $type [, $message])

Checks if the result_type is correct

=cut

sub result_type_is($$;$)
   {
   my $result  = shift;
   my $type    = shift;
   my $message = shift // "Result type is '$type'";

   return is( $result->{result_type}, $type, $message );
   }


=head2 row_type_is($result, $type [, $message])

Checks if the row_type is correct

=cut

sub row_type_is($$;$)
   {
   my $result  = shift;
   my $type    = shift;
   my $message = shift // "Row type is '$type'";

   return is( $result->{row_type}, $type, $message );
   }



=head2 result_unit_is($result, $unit[, $message])

Checks if the result_unit is correct

=cut

sub result_unit_is($$;$)
   {
   my $result  = shift;
   my $unit    = shift;
   my $message = shift // "Result Unit is '$unit'";

   return is( $result->{result_unit}, $unit, $message );
   }



=head2 result_is($result, $expected [, $message])

Compares the result with expected value.

=cut

sub result_is($$;$)
   {
   my $result   = shift;
   my $expected = shift;
   my $message  = shift // "Result is '$expected'";

   return is( $result->{result}, $expected, $message );
   }


=head2 result_cmp($result, $operator, $expected [, $message])

Compares the result with the operator and the expercted value, like cmp_ok.

=cut

sub result_cmp($$$;$)
   {
   my $result   = shift;
   my $operator = shift;
   my $expected = shift;
   my $message  = shift // "Comparere result with operator '$operator' to '$expected'";

   return cmp_ok( $result->{result}, $operator, $expected, $message );
   }



1;


