use strict;
use warnings;

use Test::More;
use App::HTTPThis;
use Cwd qw(getcwd);
use File::Temp qw(tempdir);

sub make_config {
  my ($contents) = @_;
  my $dir = tempdir(CLEANUP => 1);
  my $file = "$dir/http_thisrc";
  open my $fh, '>', $file or die "cannot create config '$file': $!";
  print {$fh} $contents;
  close $fh;
  return $file;
}

sub new_app {
  my (@argv) = @_;
  local @ARGV = @argv;
  my $orig = getcwd();
  my $tmp = tempdir(CLEANUP => 1);
  local $ENV{HOME} = $tmp;
  chdir $tmp or die "cannot chdir to '$tmp': $!";
  my $app = App::HTTPThis->new;
  chdir $orig or die "cannot chdir back to '$orig': $!";
  return $app;
}

subtest 'defaults host to localhost when unset' => sub {
  local $ENV{HTTP_THIS_CONFIG};
  my $app = new_app();
  is $app->{host}, '127.0.0.1', 'host defaults to localhost';
};

subtest 'reads host from config file' => sub {
  my $config = make_config("host=0.0.0.0\n");
  local $ENV{HTTP_THIS_CONFIG} = $config;
  my $app = new_app();
  is $app->{host}, '0.0.0.0', 'host is read from config file';
};

subtest 'command line host overrides config host' => sub {
  my $config = make_config("host=0.0.0.0\n");
  local $ENV{HTTP_THIS_CONFIG} = $config;
  my $app = new_app('--host', '::1');
  is $app->{host}, '::1', 'command line host wins over config host';
};

subtest '--all sets host to 0.0.0.0' => sub {
  local $ENV{HTTP_THIS_CONFIG};
  my $app = new_app('--all');
  is $app->{host}, '0.0.0.0', '--all binds to all interfaces';
};

subtest '--promiscuous sets host to 0.0.0.0' => sub {
  local $ENV{HTTP_THIS_CONFIG};
  my $app = new_app('--promiscuous');
  is $app->{host}, '0.0.0.0', '--promiscuous binds to all interfaces';
};

subtest 'config all=1 sets host to 0.0.0.0' => sub {
  my $config = make_config("all=1\n");
  local $ENV{HTTP_THIS_CONFIG} = $config;
  my $app = new_app();
  is $app->{host}, '0.0.0.0', 'all=1 in config binds to all interfaces';
};

subtest 'CLI --host overrides config all=1' => sub {
  my $config = make_config("all=1\n");
  local $ENV{HTTP_THIS_CONFIG} = $config;
  my $app = new_app('--host', '127.0.0.1');
  is $app->{host}, '127.0.0.1', '--host on CLI overrides config all=1';
};

done_testing;
