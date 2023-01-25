require 'digest'

module Sprockets::Vue::Utils
  module_function

  JS_ESCAPE_MAP = {
    "\\"    => "\\\\",
    "</"    => '<\/',
    "\r\n"  => '\n',
    "\n"    => '\n',
    "\r"    => '\n',
    '"'     => '\\"',
    "'"     => "\\'",
    "`"     => "\\`",
    "$"     => "\\$"
  }

  def node_regex(tag)
    %r(
    \<#{tag}
      ((\s+lang=["'](?<lang>\w+)["'])|(?<scoped>\s+scoped))*
    \>
      (?<content>.+)
    \<\/#{tag}\>
    )mx
  end

  def scope_key(data)
    Digest::MD5.hexdigest data
  end

  def escape_javascript(javascript)
    javascript = javascript.to_s
    return '' if javascript.empty?

    javascript.gsub(/(\\|<\/|\r\n|\342\200\250|\342\200\251|[\n\r"']|[`]|[$])/u, JS_ESCAPE_MAP)
  end
end
