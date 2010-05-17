require File.dirname(__FILE__) + '/../test_helper'

Factory.define :wiki do |g|
  g.name 'A wiki'
end

class WikisControllerTest < ActionController::TestCase
  include Authlogic::TestCase
  setup :activate_authlogic
  
  fixtures :all
  
  test "should get index" do
    get :index
    assert_response :success
  end
  
  test "should create wiki with current user as owner" do
    login_as :quentin
    
    assert_difference Wiki, :count do
      post :create, :wiki => {:name => 'Foo Wiki'}
    end
    
    assert assigns(:wiki).is_owned_by?(users(:quentin))
    
  end
  
  test "should not show private group to non member" do
    wiki = Factory(:wiki, :public => false)
    login_as :quentin
    get :show, :id => wiki
    assert_response :redirect
  end
  
  test "should show private group to member" do
    wiki = Factory(:wiki, :public => false)
    wiki.add_member users(:aaron)
    
    login_as :aaron
    get :show, :id => wiki
    assert_response :success    
  end
end
