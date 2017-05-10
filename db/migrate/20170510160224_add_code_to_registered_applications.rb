class AddCodeToRegisteredApplications < ActiveRecord::Migration
  def change
    add_column :registered_applications, :code, :integer, :default => rand(10000)
  end
end
