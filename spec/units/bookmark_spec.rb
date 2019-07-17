require './lib/bookmark'
require 'database_helpers'

describe Bookmark do
  describe '.all' do
    it 'returns all bookmarks' do
      connection = PG.connect(dbname: 'bookmark_manager_test')

      bookmark = Bookmark.create(url: 'http://www.makersacademy.com', title: 'Makers Academy')
      Bookmark.create(url: 'http://www.destroyallsoftware.com', title: 'Destroy All Software')
      Bookmark.create(url: 'http://www.google.com', title: 'Google')

      bookmarks = Bookmark.all

      expect(bookmarks.length).to eq 3
      expect(bookmarks.first).to be_a Bookmark
      expect(bookmarks.first.id).to eq bookmark.id
      expect(bookmarks.first.title).to eq 'Makers Academy'
      expect(bookmarks.first.url).to eq 'http://www.makersacademy.com'

    end
  end
  describe '.create' do
    it 'creates new bookmark' do
      bookmark = Bookmark.create(title: 'Test', url: 'http://testy.test.com')
      persisted_data = persisted_data(id: bookmark.id)
      expect(bookmark).to be_a Bookmark
      expect(bookmark.id).to eq persisted_data['id']
      expect(bookmark.title).to eq 'Test'
      expect(bookmark.url).to eq 'http://testy.test.com'
    end

  end

  describe '.delete' do
    it 'deletes a bookmark' do
      bookmark = Bookmark.create(title: 'Mamamia', url:'http://www.mamamia.com')
      Bookmark.delete(id: bookmark.id)
      expect(Bookmark.all.length).to eq 0
    end
  end

  describe '.edit' do
    it 'edits a bookmark' do
      bookmark = Bookmark.create(title: 'Mamamia', url:'http://www.mamamia.com')
      edited_bookmark = Bookmark.edit(id: bookmark.id, url: 'http:/www.awesomemamamia.com')
      expect(edited_bookmark).to be_a Bookmark
      expect(edited_bookmark.id).to eq bookmark.id
      expect(edited_bookmark.url).to eq 'http:/www.awesomemamamia.com'
    end
  end

  describe '.find' do
    it 'returns the requested bookmark object' do
      bookmark = Bookmark.create(title: 'Makers Academy', url: 'http://www.makersacademy.com')

       result = Bookmark.find(id: bookmark.id)

       expect(result).to be_a Bookmark
      expect(result.id).to eq bookmark.id
      expect(result.title).to eq 'Makers Academy'
      expect(result.url).to eq 'http://www.makersacademy.com'
    end
  end
end
