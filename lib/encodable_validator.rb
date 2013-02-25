require 'active_model/validators/encodable_validator'

# EncodableValidator
#
# @example
#   validates :username, :encodable => { :encodings => [Encoding::ISO_2022_JP, Encoding::Shift_JIS] }
#   or
#   validates_encodable_of :username, :encodings => [Encoding::ISO_2022_JP, Encoding::Shift_JIS]
module EncodableValidator
end
