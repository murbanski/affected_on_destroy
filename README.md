# affected_on_destroy

affected_on_destroy is a simple Rails plugin that recursively reflects on defined associations and lets you know which records will be deleted/nullified when using <b>:dependent => :destroy</b> or <b>:dependent => :nullify</b>.

## Installation

    config.gem 'murbanski-affected_on_destroy', :lib => 'affected_on_destroy', :source => 'http://gems.github.com'


## Usage

schema.rb:

	create_table "users", :force => true do |t|
	  t.string   "login"
	  t.string   "password"
	  t.datetime "created_at"
	  t.datetime "updated_at"
	end

	create_table "blogs", :force => true do |t|
	  t.integer  "user_id"
	  t.string   "name"
	  t.datetime "created_at"
	  t.datetime "updated_at"
	end

	create_table "posts", :force => true do |t|
	  t.integer  "blog_id"
	  t.text     "content"
	  t.datetime "created_at"
	  t.datetime "updated_at"
	end


 

models:

	class User < ActiveRecord::Base
	  has_many :blogs, :dependent => :destroy
	end
	
	class Blog < ActiveRecord::Base
	  belongs_to :user
	  has_many :posts, :dependent => :nullify
	end
	
	class Post < ActiveRecord::Base
	  belongs_to :blog
	end


Sample script/console session:

	>>  marcin = User.create(:login => 'marcin', :password => 'my_pass')
	=> #<User id: 1, login: "marcin", password: "my_pass", created_at: "2009-06-26 01:47:36", updated_at: "2009-06-26 01:47:36">

	>> blog = marcin.blogs.create(:name => 'My Ruby Blog')
	=> #<Blog id: 1, user_id: 1, name: "My Ruby Blog", created_at: "2009-06-26 01:47:57", updated_at: "2009-06-26 01:47:57">

	>> blog.posts.create(:content => 'Ruby tricks #1')
	=> #<Post id: 1, blog_id: 1, content: "Ruby tricks #1", created_at: "2009-06-26 01:48:40", updated_at: "2009-06-26 01:48:40">
	>> blog.posts.create(:content => 'Ruby tricks #2')
	=> #<Post id: 2, blog_id: 1, content: "Ruby tricks #2", created_at: "2009-06-26 01:48:45", updated_at: "2009-06-26 01:48:45">

What records will be affected when we destroy user 'marcin'?

	>> marcin.affected_on_destroy
	=> [#<Blog id: 1, user_id: 1, name: "My Ruby Blog", created_at: "2009-06-26 01:47:57", updated_at: "2009-06-26 01:47:57">, 
	#<Post id: 1, blog_id: 1, content: "Ruby tricks #1", created_at: "2009-06-26 01:48:40", updated_at: "2009-06-26 01:48:40">, 
	#<Post id: 2, blog_id: 1, content: "Ruby tricks #2", created_at: "2009-06-26 01:48:45", updated_at: "2009-06-26 01:48:45">]

Which models are affected when destroying user?

	>> User.affected_on_destroy
	=> ["Blog", "Post"]

Same for blog:

	>> Blog.affected_on_destroy
	=> ["Post"]


## Rails Version

Works on Rails 2.3 and 2.2


