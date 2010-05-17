class WikiNotifier < UserNotifier

  def membership_invitation(wiki_membership)
    setup_email(wiki_membership.user)
    @subject    += "You have been invited to join the #{wiki_membership.wiki.name} wiki!"
    body[:wiki_membership] = wiki_membership
    body[:url] = activate_wiki_membership_url(wiki_membership.wiki, wiki_membership)
  end

end