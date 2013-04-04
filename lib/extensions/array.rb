require 'ostruct'

# monkey patch a few useful methods onto Array
class Array
  def ostructify
    map {|i| (i.is_a?(Hash) || i.is_a?(Array)) ? i.ostructify : i }
  end
end
