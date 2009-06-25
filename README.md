# affected_on_destroy

PaperTrail lets you track changes to your models' data.  It's good for auditing or versioning.  You can see how a model looked at any stage in its lifecycle, revert it to any version, and even undelete it after it's been destroyed.

## Installation

    `config.gem 'murbanski-affected_on_destroy', :lib => 'affected_on_destroy', :source => 'http://gems.github.com'`


## Usage

Prepare schema and models:
	create_table "posts", :force => true do |t| 
	  t.integer  "user_id"
	  t.text     "content"
	  t.datetime "created_at"
	  t.datetime "updated_at"
	end 

	create_table "users", :force => true do |t| 
	  t.string   "login"
	  t.string   "password"
	  t.datetime "created_at"
	  t.datetime "updated_at"
	end 


	class User < ActiveRecord::Base
	  has_many :posts, :dependent => :destroy
	end

	class Post < ActiveRecord::Base
	  belongs_to :user
	end

Sample script/console session:
	>> m = User.create(:login => 'marcin', :password => 'my_pass')
	=> #<User id: 1, login: "marcin", password: "my_pass", created_at: "2009-06-25 23:27:54", updated_at: "2009-06-25 23:27:54">

	m.posts.create(:content => 'Sample post')
	=> #<Post id: 1, user_id: 1, content: "Sample post", created_at: "2009-06-25 23:28:46", updated_at: "2009-06-25 23:28:46">

	>> m.posts.create(:content => 'My second post')
	=> #<Post id: 2, user_id: 1, content: "My second post", created_at: "2009-06-25 23:30:08", updated_at: "2009-06-25 23:30:08">

	# which models are affected when destroying user?
	>> User.affected_on_destroy
	=> ["Post"]

	# what records will be affected when we destroy user 'marcin'?
	>> m.affected_on_destroy
	=> [#<Post id: 1, user_id: 1, content: "Sample post", created_at: "2009-06-25 23:28:46", updated_at: "2009-06-25 23:28:46">, #<Post id: 2, user_id: 1, content: "My second post", created_at: "2009-06-25 23:30:08", updated_at: "2009-06-25 23:30:08">]

	# a bit cleaner summary only with model name and id from database:
	>> puts m.affected_on_destroy_info
	Post 1
	Post 2


## Rails Version

Known to work on Rails 2.3 and 2.2


