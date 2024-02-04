module ApplicationHelper

def gravatar(user, opts = {})
	size = opts[:size || 500]

	  hash = Digest::MD5.hexdigest(user.email.downcase)
	  "https://secure.gravatar.com/avatar/#{hash}.png?s=#{size}"
 end

end
