use strict;
use Test::More;
use WWW::JMA::EarthQuake;
use utf8;

{
  my $e;
  subtest 'prepare' => sub {
    $e = WWW::JMA::EarthQuake->new();
    isa_ok($e, 'WWW::JMA::EarthQuake', 'can new');

    done_testing();
  };

  subtest 'info' => sub {
    $e->parse_info();
    my $info = $e->get_info();

    isa_ok $info, 'HASH', 'get infomation.';

    done_testing();
  };

  done_testing();
}
