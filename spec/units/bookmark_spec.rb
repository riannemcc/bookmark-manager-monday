require './lib/bookmark'
require './spec/database_helpers.rb'

describe Bookmark do
  let(:comment_class) { double(:comment_class) }
  let(:tag_class) { double(:tag_class) }

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
      persisted_data = persisted_data(id: bookmark.id, table: 'bookmarks')
      expect(bookmark).to be_a Bookmark
      expect(bookmark.id).to eq persisted_data.first['id']
      expect(bookmark.title).to eq 'Test'
      expect(bookmark.url).to eq 'http://testy.test.com'
    end

    it 'does not create a new bookmark if the URL is not valid' do
      Bookmark.create(url: 'not a real bookmark', title: 'not a real bookmark')
      expect(Bookmark.all).not_to include 'not a real bookmark'
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
      edited_bookmark = Bookmark.create(title: 'Mamamia', url:'http://www.mamamia.com')
      edited_bookmark = Bookmark.edit(id: edited_bookmark.id, title: 'Mamamia', url: 'http:/www.awesomemamamia.com')
      expect(edited_bookmark).to be_a Bookmark
      expect(edited_bookmark.id).to eq edited_bookmark.id
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

  describe '.where' do
    it 'returns bookmarks with the given tag id' do
      bookmark = Bookmark.create(url: "http://www.makersacademy.com", title: "Makers Academy")
      tag1 = Tag.create(content: 'test tag 1')
      tag2 = Tag.create(content: 'test tag 2')
      BookmarkTag.create(bookmark_id: bookmark.id, tag_id: tag1.id)
      BookmarkTag.create(bookmark_id: bookmark.id, tag_id: tag2.id)

      bookmarks = Bookmark.where(tag_id: tag1.id)
      result = bookmarks.first

      expect(bookmarks.length).to eq 1
      expect(result).to be_a Bookmark
      expect(result.id).to eq bookmark.id
      expect(result.title).to eq bookmark.title
      expect(result.url).to eq bookmark.url
    end
  end

  describe '#comments' do
    it 'returns a list of comments on the bookmark' do
      bookmark = Bookmark.create(title: 'Makers Academy', url: 'http://www.makersacademy.com')
      DatabaseConnection.query("INSERT INTO comments (id, text, bookmark_id) VALUES(1, 'Test comment', #{bookmark.id})")

      comment = bookmark.comments.first

      expect(comment.text).to eq 'Test comment'
    end
  end

  describe '#comments' do
    it 'calls .where on the Comment class' do
      bookmark = Bookmark.create(title: 'Makers Academy', url: 'http://www.makersacademy.com')
      expect(comment_class).to receive(:where).with(bookmark_id: bookmark.id)

      bookmark.comments(comment_class)
    end
  end

  describe '#tags' do
    it 'calls .where on the Tag class' do
      bookmark = Bookmark.create(title: 'Makers Academy', url: 'http://www.makersacademy.com')
      expect(tag_class).to receive(:where).with(bookmark_id: bookmark.id)

      bookmark.tags(tag_class)
    end
  end
end
