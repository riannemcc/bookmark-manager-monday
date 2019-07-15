feature 'Testing Index Page' do
  scenario 'index page returns hello world' do
    visit('/')
    expect(page).to have_content 'Hello, world'
  end

  scenario 'get directed to the bookmark page' do
    visit('/')
    click_button 'Show Bookmarks'
    expect(page).to have_content 'http://www.makersacademy.com'
    expect(page).to have_content 'http://google.com'
    expect(page).to have_content 'http://www.destroyallsoftware.com'
  end
end
