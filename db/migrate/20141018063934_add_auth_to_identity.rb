class AddAuthToIdentity < ActiveRecord::Migration
  def change
    add_column :identities, :auth, :text
  end
end
