require 'pg'

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

  scenario 'The bookmark must be a valid URL' do
  visit('/bookmarks/new')
  fill_in('url', with: 'not a real bookmark')
  click_button('Submit')

  expect(page).not_to have_content "not a real bookmark"
  expect(page).to have_content "You must submit a valid URL."
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

feature 'Updating a bookmark' do
  scenario 'A user can update a bookmark' do
    bookmark = Bookmark.create(title: 'Makers Academy', url: 'http://www.makersacademy.com')
    visit('/')
    expect(page).to have_link('Makers Academy', href: 'http://www.makersacademy.com')

     first('.bookmark').click_button 'Edit'
    expect(current_path).to eq "/bookmarks/#{bookmark.id}/edit"

     fill_in('url', with: "http://www.snakersacademy.com")
    fill_in('title', with: "Snakers Academy")
    click_button('Submit')

     expect(current_path).to eq '/'
    expect(page).not_to have_link('Makers Academy', href: 'http://www.makersacademy.com')
    expect(page).to have_link('Snakers Academy', href: 'http://www.snakersacademy.com')
  end
end

feature 'Adding and viewing comments' do
  feature 'a user can add and then view a comment' do
    scenario 'a comment is added to a bookmark' do
      bookmark = Bookmark.create(url: 'http://www.makersacademy.com', title: 'Makers Academy')

      visit '/'
      click_button 'Add Comment'

      expect(current_path).to eq "/bookmarks/#{bookmark.id}/comments/new"

      fill_in 'comment', with: 'This is a second comment'
      click_button 'Submit'

      expect(current_path).to eq '/'
      expect(page).to have_content 'This is a second comment'
    end
  end
end

feature 'Adding and viewing tags' do
  feature 'a user can add and then view a tag' do
    scenario 'a comment is added to a bookmark' do
      bookmark = Bookmark.create(url: 'http://www.makersacademy.com', title: 'Makers Academy')

      visit '/'
      click_button 'Add Tag'

      expect(current_path).to eq "/bookmarks/#{bookmark.id}/tags/new"

      fill_in 'tag', with: 'test tag'
      click_button 'Submit'

      expect(current_path).to eq '/'
      expect(page).to have_content 'test tag'
    end
  end

  feature 'a user can filter bookmarks by tag' do
      scenario 'adding the same tag to multiple bookmarks then filtering by tag' do
        Bookmark.create(url: 'http://www.makersacademy.com', title: 'Makers Academy')
        Bookmark.create(url: 'http://www.destroyallsoftware.com', title: 'Destroy All Software')
        Bookmark.create(url: 'http://www.google.com', title: 'Google')

        visit('/')

        within page.find('.bookmark:nth-of-type(1)') do
          click_button 'Add Tag'
        end
        fill_in 'tag', with: 'testing'
        click_button 'Submit'

        within page.find('.bookmark:nth-of-type(2)') do
          click_button 'Add Tag'
        end
        fill_in 'tag', with: 'testing'
        click_button 'Submit'

        first('.bookmark').click_link 'testing'

        expect(page).to have_link 'Makers Academy', href: 'http://www.makersacademy.com'
        expect(page).to have_link 'Destroy All Software',  href: 'http://www.destroyallsoftware.com'
        expect(page).not_to have_link 'Google', href: 'http://www.google.com'
      end
    end

    feature 'registration' do
      scenario 'a user can sign up' do
        visit '/users/new'
        fill_in('email', with: 'test@example.com')
        fill_in('password', with: 'password123')
        click_button('Submit')

        expect(page).to have_content "Welcome, test@example.com"
      end
    end

    feature 'Authentication' do
      scenario 'a user can sign in' do
        User.create(email: 'test@example.com', password: 'password123')

        visit '/sessions/new'
        fill_in :email, with: 'test@example.com'
        fill_in :password, with: 'password123'
        click_button('Sign in')

        expect(page).to have_content 'Welcome, test@example.com'
      end

      scenario 'a user sees an error if they get their email wrong' do
        User.create(email: 'test@example.com', password: 'password123')

        visit '/sessions/new'
        fill_in(:email, with: 'nottherightemail@me.com')
        fill_in(:password, with: 'password123')
        click_button('Sign in')

        expect(page).not_to have_content 'Welcome, test@example.com'
        expect(page).to have_content 'Please check your email or password.'
      end
    end
end
