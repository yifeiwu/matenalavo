class Post < ActiveRecord::Base
  extend FriendlyId
  include AlgoliaSearch
  algoliasearch do
    attribute :title, :contact, :content, :category, :id, :created_at, :slug
  end

  friendly_id :title, use: :slugged

  POST_TYPES = ['Jobs', 'Cars for Sale', 'Properties for Sale', 'Things for Sale', 'Something Else'].freeze
  validates :title, :contact, :content, presence: true
  validates :title, length: { maximum: 40 }
  before_save :fix_title, :replace_frags

  mount_uploader :postpic, PostpicUploader

  protected

  def fix_title
    self.title = title.titleize
  end

  def replace_frags
    self.content = content.gsub(/\/i+/, ' ')
    self.title = title.gsub(/\/i+/, ' ')

    self.content = content.gsub(/&amp;Amp;/, '&')
    self.title = title.gsub(/&Amp;/, '&')
  end

  

  end
