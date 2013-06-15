module TypographyHelper

  require 'typogruby'
  include Typogruby

  def typogrify(text)
    improve text
  end
end
