require 'pg'


class Bookmark
  attr_reader :id, :title, :url

  def initialize(id:, title:, url:)
    @id  = id
    @title = title
    @url = url
  end

  def self.all
    if ENV['ENVIRONMENT'] == 'test'
    connection = PG.connect( dbname: 'bookmark_manager_test')
    else
    connection = PG.connect( dbname: 'bookmark_manager' )
    end
    bookmarks = connection.exec("SELECT * FROM bookmarks;")
    bookmarks.map do |bookmark|
      Bookmark.new(
        id: bookmark['id'],
        title: bookmark['title'],
        url: bookmark['url']
      )
    end
  end

  def self.create(title:, url:)
    if ENV['ENVIRONMENT'] == 'test'
    connection = PG.connect( dbname: 'bookmark_manager_test')
    else
    connection = PG.connect( dbname: 'bookmark_manager' )
    end
    result = connection.exec("INSERT INTO bookmarks (title, url) VALUES('#{title}', '#{url}') RETURNING id, title, url;")
    Bookmark.new(id: result[0]['id'], title: result[0]['title'], url: result[0]['url'])
  end

  def self.delete(id:)
    if ENV['ENVIRONMENT'] == 'test'
    connection = PG.connect( dbname: 'bookmark_manager_test')
    else
    connection = PG.connect( dbname: 'bookmark_manager' )
    end
    connection.exec("DELETE FROM bookmarks WHERE id = #{id}")
  end
end
