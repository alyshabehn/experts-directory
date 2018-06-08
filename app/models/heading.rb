class Heading < ApplicationRecord
  belongs_to :member

  def self.search(search, excluded_member_ids)
    where("heading LIKE ?", "%#{search}%").where.not(member: excluded_member_ids)
  end
end
