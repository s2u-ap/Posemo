# Note: this file was auto-generated by Module::Build::Compat version 0.4224
use ExtUtils::MakeMaker;
WriteMakefile
(
  'NAME' => 'Posemo',
  'VERSION_FROM' => 'lib/PostgreSQL/SecureMonitoring.pm',
  'PREREQ_PM' => {
                   'Config::General' => '2.5',
                   'Config::Tiny' => '2.2',
                   'DBD::Pg' => '3.005001',
                   'DBI' => '1.631',
                   'File::HomeDir' => '1',
                   'File::ShareDir' => '1.102',
                   'IO::All' => '0.84',
                   'JSON' => '2.9',
                   'Log::Log4perl' => '1.29',
                   'Moose' => '2.0401',
                   'MooseX::ConfigFromFile' => '0.04',
                   'MooseX::Getopt' => '0.37',
                   'MooseX::SimpleConfig' => '0.11',
                   'MooseX::Types::Path::Tiny' => '0.011',
                   'Readonly' => '1.03',
                   'TAP::Parser::SourceHandler::pgTAP' => '3.25',
                   'Test::Differences' => '0.64',
                   'Test::Exception' => '0.25',
                   'Test::More' => 0
                 },
  'INSTALLDIRS' => 'site',
  'EXE_FILES' => [
                   'bin/posemo.pl',
                   'bin/posemo_daemon.pl',
                   'bin/posemo_install.pl'
                 ],
  'PL_FILES' => {}
)
;
