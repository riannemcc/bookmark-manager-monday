require 'tag'
require 'bookmark'
require 'database_helpers'
require './lib/bookmark_tag.rb'

describe Tag do

  let(:bookmark_class) { double(:bookmark_class) }

  describe '.create' do
    context 'tag does not exist' do
      it 'creates a new Tag object' do
        tag = Tag.create(content: 'test tag')

        persisted_data = persisted_data(id: tag.id, table: 'tags')

        expect(tag).to be_a Tag
        expect(tag.id).to eq persisted_data.first['id']
        expect(tag.content).to eq 'test tag'
      end
    end

    context 'tag already exists' do
      it 'returns the exisiting tag' do
        tag1 = Tag.create(content: 'test tag')
        tag2 = Tag.create(content: 'test tag')

        expect(tag2.id).to eq tag1.id
      end
    end
  end

  describe '.where' do
    it 'returns tags linked to the given bookmark id' do
      bookmark = Bookmark.create(url: "http://www.makersacademy.com", title: "Makers Academy")
      tag1 = Tag.create(content: 'test tag 1')
      tag2 = Tag.create(content: 'test tag 2')
      BookmarkTag.create(bookmark_id: bookmark.id, tag_id: tag1.id)
      BookmarkTag.create(bookmark_id: bookmark.id, tag_id: tag2.id)

      tags = Tag.where(bookmark_id: bookmark.id)
      tag = tags.first

      expect(tags.length).to eq 2
      expect(tag).to be_a Tag
      expect(tag.id).to eq tag1.id
      expect(tag.content).to eq tag1.content
    end
  end
  describe '.find' do
    it 'returns a tag with the given id' do
      tag = Tag.create(content: 'test tag')

      result = Tag.find(id: tag.id)

      expect(result.id).to eq tag.id
      expect(result.content).to eq tag.content
    end
  end

  describe '#bookmarks' do
    it 'calls .where on the bookmark class' do
      tag = Tag.create(content: 'test tag')

      expect(bookmark_class).to receive(:where).with(tag_id: tag.id)

      tag.bookmarks(bookmark_class)
    end
  end
end
