module ApplicationHelper

  def sign_in_path(provider)
    "auth/#{provider.to_s}"
  end

  def bookmarklet_url
    if current_user_id
      javascript_prefix = "javascript:"
      file = File.open(File.join(Rails.root, "public", "bookmarklet.js"), "r").collect
      lines = file.collect { |line| line.strip }
      escaped = javascript_prefix + url_encode_text(lines.join(" "))
      with_user_id = escaped.gsub("USER_ID", current_user_id.to_s)
      with_user_id
    end
  end

  def url_encode_text text
    URI.escape(text, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))
  end

  def tab_class(path)
    'active' if current_page?(path)
  end

  def sort_class(sort, default = false)
    current_sort = params[:by]
    'active' if (current_sort == sort || (!current_sort && default))
  end

  def tweet_out_link(codemark)
    author = codemark.user
    if author.id == current_user_id
      short_user_url(current_user)
    else
      public_codemarks_url
    end
  end

  def codemark_topic_title(codemark)
    if codemark.topics.first
      "about #{codemark.topics.first.title}"
    else
      ""
    end
  end

  def tweet_out_text(codemark)
    author = codemark.user
    if author.id == current_user_id
      "#{codemark.link_record.url} - just added a #codemark #{codemark_topic_title(codemark)}. See my others"
    else
      "#{codemark.link_record.url} - just found a #codemark #{codemark_topic_title(codemark)}. See some more"
    end
  end
end
