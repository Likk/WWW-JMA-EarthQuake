package WWW::JMA::EarthQuake;

=head1 NAME

WWW::JMA::Earthquake - Earthquake information on Japanese.

=head1 SYNOPSIS

  use WWW::JMA::Earthquake;
  use YAML;

  my $last_info = WWW::JMA::Earthquake->new();
  warn YAML::Dump $last_info;

=head1 DESCRIPTION

WWW::JMA::Earthquake is scraping at JMA Earthquake information.

=cut

use strict;
use warnings;
use utf8;
use URI;
use Web::Scraper;

=head1 Package::Global::Variable

=over

=item B<VERSION>
=item B<SITE_URL>
=item B<INFO_URL>

=back

=cut

our $VERSION = '1.2';
our $SITE_URL = "http://www.jma.go.jp";
our $INFO_URL = "/jp/quake/";

=head1 CONSTRUCTOR AND START_UP

=head2 new

Creates and returns a new Board object.:

=cut

sub new{
  my $class = shift;
  bless { @_ }, $class;
}

=head1 METHODS

=head2 parse_info

scraping a earthquake news.:

=cut

sub parse_info {
  my $self = shift;
  my $result= ();
  my $record = ();

  #配信情報取得
  my $target_url = $SITE_URL.$INFO_URL;
  my $scraper = scraper {
    process '//table[@id="infobox"]/tr/td', 'field' => 'TEXT';
    result 'field';
  };
  $result = $scraper->scrape(URI->new($target_url));
  my $fll_text = $result;

  #地震速報を発表した年月日時分
  my ($year,$month,$i_day,$i_hour,$i_min) = ();
  if($result =~ m{平成(\d{2})年(\d{1,2})月(\d{1,2})日(\d{1,2})時(\d{1,2})分 気象庁発表}){
    $year   = $1;
    $month  = $2;
    $i_day  = $3;
    $i_hour = $4;
    $i_min  = $5;
  }

  #実際に地震が発生日時分
  my ($a_day,$a_hour,$a_min) = ();
  if($result =~ m{(\d{1,2})日(\d{1,2})時(\d{1,2})分(頃|ころ|ごろ)地震(がありました|による強い揺れを感じました)}){
    $a_day  = $1;
    $a_hour = $2;
    $a_min  = $3;
  }

  #震源地または震央地
  my $area = '';
  if($result =~ m{震(?:源|央)地は(.*)?（(.*)?北緯}){
    $area = $1;
    $area = substr($area,0,-2);#整形
  }

  #マグニチュード
  my $magnitude ='';
  if($result =~ m{（マグニチュード）は(.*)?と推定されます。}){
    $magnitude = $1;
  }

  #震度 ## [１２３４５６７]で取れなかったので(１|２|...)で
  my $shindo = '';
  if($result =~ m{(震度(１|２|３|４|５|６|７)(強|弱)?)}){
    $shindo = $1;
  }

  #各地の震度を除いた全文テキスト
  my $direction = '';
  if($result =~ m{^(.*)次の(通|とお)りです}){
    $direction = $1;
  }

  $record = {                                          #整形した情報をセット。
    year        => $year,
    month       => $month,
    i_day       => $i_day,
    i_hour      => $i_hour,
    i_min       => $i_min,
    a_day       => $a_day,
    a_hour      => $a_hour,
    a_min       => $a_min,
    area        => $area,
    magnitude   => $magnitude,
    shindo      => $shindo,
    discription => $direction,
    fullintext  => $result,
  };
  $self->{info} = $record;
}


=head2 get_info

accessor at get_info.:

#TODO replace $self->info

=cut

sub get_info { #TODO: これいらない
  my $self = shift;
  return $self->{info};
}

=head1 AUTHOR

Author Likkradyus E<lt>perl@likk.jpE<gt>

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

L<http://www.jma.go.jp/jp/quake/>

=cut

1;

__END__
