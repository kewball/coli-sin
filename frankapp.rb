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

get '/complaints' do
  erb :complaints
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
  <a href='/complaints'>Complaints</a>] | 
  <a href='/api/contacts'>/api/contacts</a> 
  ]</p>
<p><strong>The Contacts</strong></p>
<ul>
  <% @kall.each do |komrade| %>
    <li>
      <%= komrade.name %> 
      <%= komrade.id.to_s %>
      <a href="/api/contact/<%= komrade.id.to_s %>">api/contact/:id</a>
    </li>
  <% end %>
</ul>


@@ complaints
<p><a href='/'>to the beginning</a></p>
<p>Things that were a bit sucky</p>
<ul>
  <li>The $IP and $PORT valuses; over in Rubyland, these are 
  (obviously, in hindsight) found in ENV['IP'] and ENV['PORT'] 
  but... if you're like me, you'll expect things to be 
  more complicated so you won't even look there.</li>
  <li>So there's a Terminal with a running Mongo. Not sure how
  to daemonize it so it just sits there, running</li>
  <li>Ruby's "to_json" is convenient but it is sub-optimal when
  using MongoDB and the BSON document ID. Instead of a normal ID
  it returns an object. There are numerous ways to fix this at
  the server but I don't have the gumption right now.</li>
  <li>I should build the POST action and a form to exercise it, 
  but I'd rather take a nap...zzzz</li>
  
</ul>

