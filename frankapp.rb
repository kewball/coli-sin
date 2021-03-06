#  IP=0.0.0.0 ruby frankapp.rb
require 'sinatra'
require 'mongoid'

Mongoid.load!("mongoid.yml")

configure do
  set :port, ENV['PORT']
  set :bind, ENV['IP']
end

class Komrade
  include Mongoid::Document
  field :name
  field :number
  field :email
end

get '/' do
  @kall = Komrade.all.desc(:_id)
  erb :index
end

get '/commentary' do
  erb :commentary
end

get '/screenshots' do
  erb :screenshots
end

get '/api/contacts' do
  @kall = Komrade.all.to_json
end

get '/api/contact/:id' do
  @k = Komrade.find(params[:id]).to_json
end

post '/api/contact' do
end

post '/contact' do
  @k = Komrade.new(
    :name => params[:name],
    :email => params[:email],
    :number => params[:number]
  )
  @k.save! # no error checking at all? :/
  @kall = Komrade.all.desc(:_id)
  redirect to('/')
  # erb :index
end

get '/seed-the-db' do
  Komrade.create!(:name => 'Bob Smith', :number => 47, :email => "bob@bo.com")
  Komrade.create!(:name => 'Sam Jones', :number => 66, :email => "sam@xx.com")
  Komrade.create!(:name => 'Jo Wilson', :number => 74, :email => "jow@jw.com")
end

__END__

@@ index
<div style="float:right;"><%= Time.now %></div>
<p><strong>API Links</strong> [
  <a href='/api/contacts'>/api/contacts</a>
  ] </p>
<p><strong>Doc Links</strong> [
  <a href='/commentary'>Commentary</a> |
  <a href='/screenshots'>Screenshots</a>
  ] </p>
<p><strong>New</strong> [
  <a href='/screenshots#Sat1031'>new screenshot</a> 
  ] </p>

<p><strong>Add Contact</strong></p>

<form action="/contact" method="POST">
  <fieldset>
    <code>nam:</code> <input type="text" name="name"> <br/>
    <code>eml:</code> <input type="text" name="email"> <br/>
    <code>nbr:</code> <input type="text" name="number"> <br/>
    <input type="submit" style="margin-left:6em;">
  </fieldset>
</form>

<p><strong>The Contacts</strong></p>
<ul>
  <% @kall.each do |komrade| %>
    <li>
      <%= komrade.name %>
      <code><%= komrade.id.to_s %></code>
      [ <a href="/api/contact/<%= komrade.id.to_s %>">api/contact/:id</a> ]
    </li>
  <% end %>
</ul>


@@ commentary
<h3><a href='/'>Back</a></h3>

<p>I have several more hours into this IDE now and I can say that it works
  for me. I could use this as my "daily driver" although I did just install
  the latest version of Atom (atom.io) on my workstation. I have successfully
  pushed changes to Github from c9 and my local workstation+VM. If I were to
  setup my ssh keys at Github it would be seamless.
</p>

<p>Plus, I've "integrated" Github into the Slack. </p>

<p>It was good to get back to Sinatra after a long enough absence that I
  forgot most of the basics. I've never really understood how the "@@" magic
  occurs but it's convenient to have all the routing, logic and templates in
  one file. At the beginning of a project anyway, until that one file gets
  too large.
</p>

<p>To use this Sinatra app as an API for the Contact List project:</p>
<ol>
  <li><strong>Database</strong>
    MongoDB installed, and a Terminal running the mongod daemon
    (or figure out how to daemonize it)
  </li>
  <li><strong>Back-end server</strong>
    This Sinatra app and its gems (mongoid and sinatra) installed,
    and a Terminal window running the app
  </li>
  <li><strong>Front-end server</strong>
    The Contact List app itself (and its dependencies) ,
    and a Terminal window running the app
  </li>
</ol>

<p>Complaints</p>
<ul>
  <li>The $IP and $PORT values; over in Rubyland, these are
    (obviously, in hindsight) found in ENV['IP'] and ENV['PORT']
    but... if you're like me, you'll expect things to be
    more complicated so you won't even look there.
  </li>
  <li>Faffed around a while getting Sinatra to listen to the
    right IP/PORT. I tried creating a "Custom Runner" but that
    failed for me. Then I found out about setting :port and :bind
    in a configure block at the top of the Sinatra app itself. Sorted.
  </li>
  <li>So there's a Terminal with a running MongoDB. Not sure how
    to daemonize it so it just sits there, running.
  </li>
  <li>Ruby's "to_json" is convenient but it is sub-optimal when
    using MongoDB and its BSON document ID. Instead of a normal ID
    it returns an object <code>
    "_id":{"$oid":"563428016d09887227000000"}
    </code>.
    There are numerous ways to fix this at the server but I
    don't have the gumption right now.
  </li>
  <li><strike>I should build the POST action and a form to exercise it,
    but I'd rather take a nap...zzzz</strike> DONE.
  </li>
  <li>MongoDB should probably have a "Runner" script so its Terminal
    window would look like "frankapp.rb" with a Start/Stop button,
    reload button, etc.
  </li>
</ul>

<p>Resources</p>
<ul>
  <li><a href="http://learnrubythehardway.org/book/ex51.html">double-check
  HTML form syntax</a></li>
  <li><strong>Fixing the Mongo Runner</strong> The clue is right here 
  http://stackoverflow.com/questions/30740951/bash-command-not-found-cloud9-enviroment 
  in the answer, "Be sure your runner is set to Ruby on Rails and not Shell". 
  That, of course, isn't <em>my answer</em> but it points to the answer.</li>
</ul>


@@ screenshots

<h3><a name="sstop" href='/'>Back</a></h3>
[ <a href="#Fri1030">Fri 10/30</a> | <a href="#Sat1031">Sat 10/31</a> ]

<a name="Fri1030"></a>
<div style="padding:1em;">
<p><strong>The Workspace</strong></p>
<ul>
  <li>the MongoDB server, lower left</li>
  <li>the Sinatra app Runner, lower right</li>
  <li>the "Github" Terminal, upper right</li>
  <li>the Sinatra app code, upper left</li>
</ul>
<img src="SS-coli-sinCloud9.png" />
</div>

<a href="#sstop" name="Sat1031">up</a>
<div style="padding:1em;">
<p><strong>The Workspace</strong> The Mongo runner looks okay but I don't understand
how or why it works. Shrug. :/</p>
<ul>
  <li>the MongoDB server, lower left</li>
  <li>the Sinatra app Runner, lower right</li>
  <li>the "Github" Terminal, upper right</li>
  <li>the Sinatra app code, upper left</li>
</ul>
<img src="SS2-coli-sin-Cloud9.png" />
</div>
