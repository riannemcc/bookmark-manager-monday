feature 'Testing Index Page' do
  scenario 'index page returns hello world' do
    visit('/')
    expect(page).to have_content 'Hello, world'
  end

  scenario 'get directed to the bookmark page' do
    visit('/')
    click_button 'Show Bookmarks'
    expect(page).to have_content 'http://www.google.co.uk, http://www.facebook.com'
  end
end
