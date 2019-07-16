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

feature 'Adding a new bookmark' do
  scenario 'A user can add a bookmark to Bookmark Manager' do
    visit('/bookmarks/new')
    fill_in('title', with: 'Test')
    fill_in('url', with: 'http://testbookmark.com')
    click_button('Submit')
    expect(page).to have_content 'Test'
  end
end
end
