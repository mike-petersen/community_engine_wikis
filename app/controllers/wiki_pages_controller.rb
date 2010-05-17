class WikiPagesController < BaseController
	before_filter :find_wiki
	resource_controller
	belongs_to :wiki
	before_filter :login_required, :except => [:index, :show]
	before_filter :owner_or_admin_required, :only => [:destroy]
	before_filter :wiki_membership_required

	uses_tiny_mce(:options => AppConfig.simple_mce_options, :only => [:new, :edit, :create, :update, :show])

	create.before do
		@object.user_id = current_user.id
		@object.author  = current_user.login
		@object.ip      = request.remote_ip
	end

	new_action.before do
		@object.name = params[:name] if not params[:name].nil?
	end

	private

	def find_wiki
      @wiki = Wiki.find(params[:wiki_id])
	end

	def owner_or_admin?
      @owner_or_admin = logged_in? && (current_user.admin? || @wiki.is_owned_by?(current_user))
      @owner_or_admin
	end

	def owner_or_admin_required
      owner_or_admin? ? true : access_denied
	end

	def wiki_membership_required
      if @wiki.public?
			true
      else
			logged_in? && (current_user.admin? || current_user.is_member_of?(@wiki)) ? true : access_denied
      end
	end

	def object
		@object ||= WikiPage.find(:first, :conditions => ["address = ? AND wiki_id = ?", params[:id], @wiki.id])
	end
end
