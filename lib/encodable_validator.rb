require 'active_model/validators/encodable_validator'
require 'active_support/i18n'

# EncodableValidator
#
# @example
#   validates :username, :encodable => { :encodings => [Encoding::ISO_2022_JP, Encoding::Shift_JIS] }
#   or
#   validates_encodable_of :username, :encodings => [Encoding::ISO_2022_JP, Encoding::Shift_JIS]
module EncodableValidator
end

I18n.load_path += Dir[File.expand_path(File.join(File.dirname(__FILE__), '../locales', '*.yml')).to_s]
