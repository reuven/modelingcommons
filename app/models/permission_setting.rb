# Model to handle different permission settings

class PermissionSetting < ActiveRecord::Base
  attr_accessible :name, :short_form

  ANYONE = 1
  OWNER = 2
  GROUP = 3

  validates :name, :presence => true, :uniqueness => true
  validates :short_form, :presence => true, :uniqueness => true

  has_many :nodes

  def is_owner?
    id == PermissionSetting::OWNER
  end

  def is_group?
    id == PermissionSetting::GROUP
  end

  def is_anyone?
    id == PermissionSetting::ANYONE
  end

  def self.anyone
    find_by_short_form('a')
  end

  def self.owner
    find_by_short_form('u')
  end

  def self.group
    find_by_short_form('g')
  end

  def to_s
    name
  end

end
