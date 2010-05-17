class WikiPage < ActiveRecord::Base
	default_scope :order => 'created_at DESC'
	acts_as_versioned

	validates_presence_of :name

	has_many :wiki_memberships, :dependent => :destroy
	has_many :members, :through => :wiki_memberships, :source => :user
	has_many :active_members, :through => :wiki_memberships, :source => :user, :conditions => ["active = ?", true]

	belongs_to :wiki
	acts_as_activity :user

	# URL Parameter
	def to_param
		"#{self.name.parameterize}"
	end
	
	def user
		User.find_by_id(self.user_id)
	end

	def can_be_deleted_by(person)
		person && (person.admin? || person.id.eql?(user_id) )
	end

	protected

	def before_save
		self.address = self.name.parameterize.downcase
	end
end
