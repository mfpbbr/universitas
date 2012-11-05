# == Schema Information
#
# Table name: group_documents
#
#  id              :integer(4)      not null, primary key
#  user_id         :integer(4)
#  group_id        :integer(4)
#  document_id     :integer(4)
#  group_module_id :integer(4)
#  pending         :boolean(1)      default(FALSE)
#  created_at      :datetime
#  updated_at      :datetime
#

class GroupDocument < ActiveRecord::Base
  belongs_to :sender, :foreign_key => 'user_id', :class_name => "User"
  belongs_to :group
  belongs_to :document
  belongs_to :module, :foreign_key => 'group_module_id', :class_name => "GroupModule"
  has_many :targeted_updates, :as => :target, :dependent => :destroy, :class_name => "Update"
  
  scope :accepted, where(:pending => false)
  scope :pending, where(:pending => true)
  
  after_create :create_user_document, :create_update_if_leader, :increment_count
  delegate :name, :description, :file, :file_url, :to => :document
  accepts_nested_attributes_for :document
  after_destroy :decrement_count
  
  def accept
    self.update_attribute(:pending, false)
    self.increment_count
    self.create_update
  end
  
  def create_update
    self.group.updates.create!(:target => self)   
  end
  
  def increment_count
    self.group.update_attribute(:documents_count, self.group.documents_count + 1) unless self.pending
  end
  
  private
  
  def create_update_if_leader
    self.create_update if self.sender.leader_of?(self.group)
  end
  
  def create_user_document
    self.sender.add_document(self.document)
  end
  
  def decrement_count
    self.group.update_attribute(:documents_count, self.group.documents_count - 1) unless self.pending
  end

end


