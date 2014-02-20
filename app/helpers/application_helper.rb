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

  def link_to_modal(body, url, options={})
    remote = options.fetch(:remote, false)
    attrs = hash_to_attributes options.except! :remote
    if remote
      "<a href=\"#{url}\" rel=\"modal:open\" #{attrs} >#{body}</a>".html_safe
    else
      "<a href=\"#{url}\" data-modal=\"open\" #{attrs} >#{body}</a>".html_safe
    end
  end
end
