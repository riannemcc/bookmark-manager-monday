feature 'Testing Index Page' do
  scenario 'index page returns bookmarks' do

  connection = PG.connect(dbname: 'bookmark_manager_test')

# Add the test data
  connection.exec("INSERT INTO bookmarks (title, url) VALUES('Makers Academy', 'http://www.makersacademy.com');")
  connection.exec("INSERT INTO bookmarks (title, url) VALUES('Destroy All Software', 'http://www.destroyallsoftware.com');")
  connection.exec("INSERT INTO bookmarks (title, url) VALUES('Google', 'http://www.google.com');")
    visit('/')
    expect(page).to have_content 'Makers Academy'
    expect(page).to have_content 'Destroy All Software'
    expect(page).to have_content 'Google'
  end
end

feature 'Adding a new bookmark' do
  scenario 'A user can add a bookmark to Bookmark Manager' do
    visit('/bookmarks/new')
    fill_in('title', with: 'Test')
    fill_in('url', with: 'http://testbookmark.com')
    click_button('Submit')
    expect(page).to have_content 'Test'
  end
  scenario 'A user can add another bookmark to Bookmark Manager' do
    visit('/bookmarks/new')
    fill_in('title', with: 'Testone')
    fill_in('url', with: 'http://testbookmarkone.com')
    click_button('Submit')
    expect(page).to have_content 'Test'
  end
end

feature 'Deleting a bookmark' do
  scenario 'A user can delete a bookmark' do
    Bookmark.create(title: 'Jurassic Park', url: 'http://www.noonegoeshere.com')
    visit('/')
    expect(page).to have_link('Jurassic Park', href: 'http://www.noonegoeshere.com')

     first('.bookmark').click_button 'Delete'

     expect(current_path).to eq '/'
    expect(page).not_to have_link('Jurassic Park', href: 'http://www.noonegoeshere.com')
  end
end

feature 'Editing a bookmark' do
  scenario 'A user can edit a bookmark' do
    bookmark = Bookmark.create(title: 'Jurassic Park', url: 'http://www.noonegoeshere.com')
    visit('/')
    expect(page).to have_link('Jurassic Park', href: 'http://www.noonegoeshere.com')

     first('.bookmark').click_button 'Edit'
     expect(current_path).to eq "/bookmarks/#{bookmark.id}/edit"
     fill_in('title', with: 'Jurassic Park')
     fill_in('url', with: 'http://notjurassicpark.com')
     click_button('Submit')

     expect(current_path).to eq '/'
     # expect(page).not_to have_link('Jurassic Park', href: 'http://www.noonegoeshere.com')
     expect(page).to have_link('Jurassic Park', href: 'http://notjurassicpark.com')
  end
end
