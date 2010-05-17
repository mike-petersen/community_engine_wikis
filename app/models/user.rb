class User < ActiveRecord::Base
  has_many :wiki_memberships, :dependent => :destroy
  has_many :wikis, :through => :wiki_memberships
  
  has_many :wikis_as_owner, :through => :wiki_memberships, :source => :wiki, :conditions => ["owner = ?", true], :dependent => :destroy

  def can_request_wiki_membership?(wiki)
    wiki.membership_can_be_requested_by?(self)
  end
  
  def is_member_of?(wiki)
    wiki.member?(self)
  end
  
end
