require 'ostruct'

# monkey patch a few useful methods onto Hash
class Hash
  def ostructify
    temp = inject({}) do |hash, (key, value)|
      hash[key] = (value.is_a?(Hash) || value.is_a?(Array)) ? value.ostructify : value
      hash
    end
    OpenStruct.new temp
  end
end

