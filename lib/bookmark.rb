require 'pg'


class Bookmark

  def self.all
    bookmark_map
  end

  private

  def self.connect_to_db
    PG.connect( dbname: 'bookmark_manager' )
  end

  def self.select_table
    connect_to_db.exec("SELECT * FROM bookmarks;")
  end

  def self.bookmark_map
    select_table.map { |bookmark| bookmark['url'] }
  end

end
