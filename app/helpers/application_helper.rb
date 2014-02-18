module ApplicationHelper

  def hash_to_attributes(hash)
    # convert hash to a html attributes string
    #
    # Usage:
    #   => hash_to_attributes({:attr => "val1 val2", :class => "button"})
    #   => "attr=\"val1 val2\" class=\"button\" "
    #
    hash.map { |k, v| "#{k}=\"#{v}\"" }.join(" ")
  end

  def link_to_modal(content, href, opts={})
    attrs = hash_to_attributes opts
    "<a href=\"#{href}\" rel=\"modal:open\" #{attrs} >#{content}</a>".html_safe
  end

end
