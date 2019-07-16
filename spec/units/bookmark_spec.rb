require './lib/bookmark'
require 'database_helpers'

describe Bookmark do
  describe '.all' do
    it 'returns all bookmarks' do
      connection = PG.connect(dbname: 'bookmark_manager_test')

      connection.exec("INSERT INTO bookmarks (title, url) VALUES('Makers Academy', 'http://www.makersacademy.com');")
      connection.exec("INSERT INTO bookmarks (title, url) VALUES('Destroy All Software', 'http://www.destroyallsoftware.com');")
      connection.exec("INSERT INTO bookmarks (title, url) VALUES('Google', 'http://www.google.com');")

      bookmarks = Bookmark.all

      expect(bookmarks[0]['title']).to include 'Makers Academy'
      expect(bookmarks[1]['title']).to include 'Destroy All Software'
      expect(bookmarks[2]['title']).to include 'Google'

    end
  end
  describe '.create' do
    it 'creates new bookmark' do
      title = 'Test'
      url = 'http://testy.test.com'
      bookmark = Bookmark.create(title, url)
      persisted_data = persisted_data(id: bookmark.id)
      expect(bookmark).to be_a Bookmark
      expect(bookmark.id).to eq persisted_data['id']
      expect(bookmark.title).to eq title
      expect(bookmark.url).to eq url
    end
  end
end
