#!/usr/bin/env perl
use Mojolicious::Lite;

# Documentation browser under "/perldoc"
plugin 'PODRenderer';

get '/' => sub {
  my $c = shift;
  $c->render(template => 'index');
};

any ['GET', 'POST'] => '/:label/:content' => sub {
    my $c = shift;

    my $color = $c->param('rgb') || '4c1'; # green
    my $label = $c->param('label');
    my $content = $c->param('content');

    $c->stash(color => $color);
    $c->stash(label => $label);
    $c->stash(content => $content);
    $c->render(template => 'badge', format => 'svg');
};

app->start;
__DATA__

@@ index.html.ep
% layout 'default';
% title 'Welcome';
<h1>Welcome to the Mojolicious real-time web framework!</h1>
To learn more, you can browse through the documentation
<%= link_to 'here' => '/perldoc' %>.

@@ layouts/default.html.ep
<!DOCTYPE html>
<html>
  <head><title><%= title %></title></head>
  <body><%= content %></body>
</html>

@@ badge.svg.ep
<svg version="1.1" xmlns="http://www.w3.org/2000/svg"
    width="0" height="20" onload="void init(evt);">
  <linearGradient id="a" x2="0" y2="100%">
    <stop offset="0" stop-color="#bbb" stop-opacity=".1"/>
    <stop offset="1" stop-opacity=".1"/>
  </linearGradient>
  <rect class="full" rx="3" width="0" height="20" fill="#555"/>
  <rect class="cbg" rx="3" x="0" width="0" height="20" fill="#<%= $color %>"/>
  <path class="sep" fill="#<%= $color %>" />
  <rect class="full" rx="3" width="0" height="20" fill="url(#a)"/>
  <g fill="#fff" font-family="DejaVu Sans,Verdana,Geneva,sans-serif" font-size="11">
    <text class="label body" y="15" fill="#010101" fill-opacity=".3"><%= $label %></text>
    <text class="label shadow" y="14"><%= $label %></text>
    <text class="content body" x="62.5" y="15" fill="#010101" fill-opacity=".3"><%= $content %></text>
    <text class="content shadow" x="62.5" y="14"><%= $content %></text>
  </g>

  <script type="text/ecmascript">
    function init (evt) {
      var padding = 5;
      var svg = evt.target.ownerDocument.documentElement;
      var label = svg.querySelector(".label.body");
      var label_length = label.getComputedTextLength();
      var content = svg.querySelector(".content.body");
      var content_length = content.getComputedTextLength();
      var labels = svg.querySelectorAll(".label");
      var contents = svg.querySelectorAll(".content");
      var full = svg.querySelectorAll(".full");
      var full_length = label_length + content_length + padding * 4;
      var sep = svg.querySelector(".sep");
      var sep_start = label_length + padding * 1;
      var label_width = label_length + padding * 2;
      var content_start = label_length + padding * 3;
      var content_width = content_length + padding * 2;
      var cbg = svg.querySelector(".cbg");

      svg.setAttributeNS(null, "width", full_length);

      cbg.setAttributeNS(null, "x", label_width);
      cbg.setAttributeNS(null, "width", content_width);

      sep.setAttributeNS(null, "d", "M" + label_width + " 0h4v20h-4z");

      Array.prototype.forEach.call(full, function (elm) {
        elm.setAttributeNS(null, "width", full_length);
      });

      Array.prototype.forEach.call(labels, function (elm) {
        elm.setAttributeNS(null, "x", padding);
        elm.setAttributeNS(null, "width", label_width);
      });

      Array.prototype.forEach.call(contents, function (elm) {
        elm.setAttributeNS(null, "x", content_start);
        elm.setAttributeNS(null, "width", content_width);
      });
    }
  </script>
</svg>
