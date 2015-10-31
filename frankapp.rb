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
  @kall = Komrade.all
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

get '/seed-the-db' do
  Komrade.create!(:name => 'Bob Smith', :number => 47, :email => "bob@bo.com")
  Komrade.create!(:name => 'Sam Jones', :number => 66, :email => "sam@xx.com")
  Komrade.create!(:name => 'Jo Wilson', :number => 74, :email => "jow@jw.com")
end

__END__

@@ index
<div style="float:right;"><%= Time.now %></div>
<p><strong>Links</strong> [
  <a href='/commentary'>Commentary</a>] | 
  <a href='/screenshots'>Screenshots</a>] | 
  <a href='/api/contacts'>/api/contacts</a> 
  ]</p>
<p><strong>The Contacts</strong></p>
<ul>
  <% @kall.each do |komrade| %>
    <li>
      <%= komrade.name %> 
      <code><%= komrade.id.to_s %></code>
      <a href="/api/contact/<%= komrade.id.to_s %>">api/contact/:id</a>
    </li>
  <% end %>
</ul>


@@ commentary
<h3><a href='/'>Back</a></h3>

<p>I have several more hours into this IDE now and I can say that it works
  for me. I could use this as my "daily driver" although I did just install 
  the latest version of Atom (atom.io) on my workstation.
</p>

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
  <li>I should build the POST action and a form to exercise it, 
    but I'd rather take a nap...zzzz
  </li>
  <li>MongoDB should probably have a "Runner" script so its Terminal
    window would look like "frankapp.rb" with a Start/Stop button,
    reload button, etc.
  </li>
</ul>


@@ screenshots

<h3><a href='/'>Back</a></h3>
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


