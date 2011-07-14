use inc::Module::Install;
name 'WWW-JMA-EarthQuake';
all_from 'lib/WWW/JMA/EarthQuake.pm';

# requires '';

tests 't/*.t';
author_tests 'xt';

test_requires 'Test::More';
auto_set_repository;
auto_include;
WriteAll;
