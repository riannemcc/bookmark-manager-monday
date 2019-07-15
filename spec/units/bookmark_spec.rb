require './lib/bookmark'

describe Bookmark do
  describe '.all' do
    it 'returns all bookmarks' do
      bookmarks = Bookmark.all
      expect(bookmarks).to include("http://www.google.co.uk")
      expect(bookmarks).to include("http://www.facebook.com")
    end
  end
end
