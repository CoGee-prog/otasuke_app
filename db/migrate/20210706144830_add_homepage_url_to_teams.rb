class AddHomepageUrlToTeams < ActiveRecord::Migration[6.1]
  def change
    add_column :teams, :homepage_url, :string
  end
end
