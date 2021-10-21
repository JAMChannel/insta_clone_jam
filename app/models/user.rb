class User < ApplicationRecord
  authenticates_with_sorcery!
  # passwordというDBに存在しない仮想的な属性(virtual attributes)が追加される。これがないと保存できない
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
end
