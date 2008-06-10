= springnote_client

* Homepage: http://myruby.net/pages/1329390
* Author: deepblue(http://myruby.net)

== DESCRIPTION:

Springnote Client Library without ActiveResource

== FEATURES/PROBLEMS:

* This is a technical preview version. APIs can be changed.

== SYNOPSIS:

# Instantiate a note
note = Springnote('rubyseminar', 
  :app_key => '__YOUR_APP_KEY__',
  :user_openid => 'http://openid.myid.net/',
  :user_key => '__YOUR_USER_KEY__')

# Get a page
page = note.pages.find(1325546)
puts page.title

# Update a page
page.title += '_'
page.source += '_'
page.save

# Create a page
page = note.pages.build(:title => Time.now.to_s, :source => Time.now.to_s, :relation_is_part_of => 1329222)
page.save

# Get several pages
pages = note.pages.find(1325546, 1325544)
puts pages.map{|page| page.title}.join(',')
 

== REQUIREMENTS:

* rest_client
* active_support

== INSTALL:

* sudo gem install springnote_client

== LICENSE:

(The MIT License)

Copyright (c) 2008 Bryan Kang

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.