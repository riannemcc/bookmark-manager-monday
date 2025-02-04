require 'pg'
require_relative 'database_connection'
require 'uri'
require_relative './comment.rb'
require_relative './tag'


class Bookmark
  attr_reader :id, :title, :url

  def initialize(id:, title:, url:)
    @id  = id
    @title = title
    @url = url
  end

  def self.all
    result = DatabaseConnection.query("SELECT * FROM bookmarks")
    result.map do |bookmark|
      Bookmark.new(id: bookmark['id'],
        url: bookmark['url'],
        title: bookmark['title']
      )
    end
  end

  def self.create(title:, url:)
    return false unless is_url?(url)
    result = DatabaseConnection.query("INSERT INTO bookmarks (url,
    title) VALUES('#{url}', '#{title}') RETURNING id, title, url;")
    Bookmark.new(id: result[0]['id'], title: result[0]['title'],
    url: result[0]['url'])
  end

  def self.delete(id:)
    DatabaseConnection.query("DELETE FROM bookmarks WHERE id = #{id}")
  end

  def self.edit(id:, url:, title:)
    result = DatabaseConnection.query("UPDATE bookmarks SET url = '#{url}',
      title = '#{title}' WHERE id = #{id} RETURNING id, url, title;")
    Bookmark.new(id: result[0]['id'], title: result[0]['title'], url: result[0]['url'])
  end

  def self.find(id:)
    result = DatabaseConnection.query("SELECT * FROM bookmarks WHERE id = #{id}")
    Bookmark.new(id: result[0]['id'], title: result[0]['title'], url: result[0]['url'])
  end

  def self.where(tag_id:)
    result = DatabaseConnection.query("SELECT id, title, url FROM bookmarks_tags INNER JOIN bookmarks ON bookmarks.id = bookmarks_tags.bookmark_id WHERE bookmarks_tags.tag_id = '#{tag_id}';")
    result.map do |bookmark|
      Bookmark.new(id: bookmark['id'], title: bookmark['title'], url: bookmark['url'])
    end
  end

  def comments(comment_class = Comment)
   comment_class.where(bookmark_id: id)
  end

  def tags(tag_class = Tag)
    tag_class.where(bookmark_id: id)
  end

  private

   def self.is_url?(url)
    url =~ URI::DEFAULT_PARSER.regexp[:ABS_URI]
   end

end
