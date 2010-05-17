# Plugin routes go here
# app this to your app's routes file to make these routes active:

resources :wikis do |wiki|
	wiki.resources :wiki_pages, :controller => "wiki_pages"
	wiki.resources :memberships, :controller => "wiki_memberships", :member => {:activate => :any, :deactivate => :put}, :collection => {:invite => :any, :auto_complete_for_username => :any}
end

user_wiki '/:user_id/wikis/:id', :controller => 'wikis', :action => 'show'
user_wiki_page '/:user_id/wikis/:id/pages/:id', :controller => 'wiki_pages', :action => 'show'
wiki_page_photo '/wikis/:wiki_id/wiki_pages/:wiki_page_id/photos', :controller => 'wiki_photos', :action => 'index'
