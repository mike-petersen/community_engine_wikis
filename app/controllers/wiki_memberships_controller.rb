class WikiMembershipsController < BaseController
  before_filter :find_wiki
  before_filter :wiki_membership_required, :only => [:index]
  before_filter :login_required,            :only => [:create, :destroy, :activate, :deactivate]
  before_filter :owner_or_admin_required,   :only => [:invite]  

  skip_before_filter :verify_authenticity_token, :only => [:auto_complete_for_username]
  
  def auto_complete_for_username
    @users = User.find(:all, :conditions => [ 'LOWER(login) LIKE ?', '%' + (params[:user_names]) + '%' ])
    render :inline => "<%= auto_complete_result(@users, 'login') %>"
  end

  def create
    @user  = current_user
    @wiki.add_member(@user)
    
    flash[:notice] = :user_joined_wiki.l
    
    redirect_to @wiki
  end
  
  def destroy
    wiki_membership = @wiki.wiki_memberships.find(params[:id])
    
    wiki_membership.destroy if (wiki_membership.can_be_removed_by?(current_user))
    
    if owner_or_admin?
      flash[:notice] = :user_was_removed_by_wiki_owner.l
    else
      flash[:notice] = :user_left_wiki.l
    end
    
    redirect_to @wiki
  end
  
  def index
    if owner_or_admin?
      @wiki_memberships = @wiki.wiki_memberships.find(:all, :page => {:current => params[:page], :size => 20})
    else
      @wiki_memberships = @wiki.wiki_memberships.active.find(:all, :page => {:current => params[:page], :size => 20})
    end
  end

  def invite        
    if request.post?
      params[:user_names].split(',').uniq.each do |user_name|
        user = User.find_by_login(user_name.strip)
        @wiki.add_member(user, {:active => false})
      end
      redirect_to :action => :index
    end
  end

  def activate
    wiki_membership = @wiki.wiki_memberships.find(params[:id])
    wiki_membership.activate if wiki_membership.can_be_removed_by?(current_user)
    flash[:notice] = :the_user_was_activated.l

    redirect_to owner_or_admin? ? {:action => :index} : wiki_path(@wiki)
  end
  
  def deactivate
    wiki_membership = @wiki.wiki_memberships.find(params[:id])
    wiki_membership.deactivate if wiki_membership.can_be_removed_by?(current_user)

    redirect_to owner_or_admin? ? {:action => :index} : wiki_path(@wiki)
  end  


  private
  
    def owner_or_admin?
      @owner_or_admin = logged_in? && (current_user.admin? || @wiki.is_owned_by?(current_user))
      @owner_or_admin
    end
  
    def owner_or_admin_required
      owner_or_admin? ? true : access_denied
    end
  
    def find_wiki
      @wiki = Wiki.find(params[:wiki_id])
    end
    
    def wiki_membership_required
      if @wiki.public?
        true
      else
        logged_in? && (current_user.admin? || current_user.is_member_of?(@wiki)) ? true : access_denied
      end
    end

end