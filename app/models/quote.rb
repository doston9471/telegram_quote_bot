class Quote < ApplicationRecord
  has_rich_text :text
  has_one_attached :image

  validates :text, presence: true
  validates :author, presence: true
  validates :category, presence: true

  scope :by_category, ->(category) { where(category: category) }

  def self.random_quote
    order("RANDOM()").first
  end

  def self.all_categories
    distinct.pluck(:category).sort
  end
end
