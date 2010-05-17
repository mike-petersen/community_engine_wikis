module WikiPagesHelper
	def format_wiki_page(wiki, content)
		content = content.gsub(/\[\[(\w+)\]\]/) {|match| match = match.gsub("[[", "").gsub("]]", ""); link_to(match, wiki_wiki_page_path(wiki, :id => match.parameterize.downcase))}
		content = content.gsub(/\[\[(\w+)\|(\w+)\]\]/) {|match| tmp = match.gsub("[[", "").gsub("]]", "").split("|"); link_to(tmp[1], wiki_wiki_page_path(wiki, :id => tmp[0].parameterize.downcase))}

		return content
	end
end
