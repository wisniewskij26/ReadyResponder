require 'spec_helper'

describe Notification do
  before (:each)  do
    somebody = FactoryGirl.create(:user)
    r = FactoryGirl.create(:role, name: 'Editor')
    somebody.roles << r
    visit new_user_session_path
    fill_in 'user_email', :with => somebody.email
    fill_in 'user_password', :with => somebody.password
    click_on 'Sign in'
  end

  describe 'creation' do
    let(:notification)   { FactoryGirl.create(:notification)}
    let!(:event) { FactoryGirl.create(:event)}

    it "creates" do
      visit new_event_notification_path(event)
      select 'email', :from => 'notification_channels'
      fill_in "Subject", with: "Pay Attention"
      fill_in "Body", with: 'Please respond soon'
      fill_in 'Comments', with: "These are comments"
      click_on 'Create'
      page.should have_content "Notification was successfully created."
    end
  end
  describe "displays" do
    let(:event) { FactoryGirl.create(:event)}
    let(:notification)   { FactoryGirl.create(:notification, event: event)}

    it 'an edit form' do
      notification.stub(:event).and_return(event)
      visit edit_notification_path(notification)
      within("#sidebar") do
        page.should have_content("Cancel")
      end
    end

    it "a show page" do
      visit event_notification_path(event, notification)
      within('#sidebar') do
        page.should have_content "Return to"
      end
      page.should have_content(event.title)
      current_path.should == event_notification_path(event, notification)
    end
    it "hides the course if category isn't training" , js: true do
      visit new_event_path
      select 'Patrol', :from => 'event_category'
      fill_in "Description", with: "Really Long Text..."  #This ensures the blur event happens
      page.should_not have_content("Course")
      select 'Training', :from => 'event_category'
      fill_in "Description", with: "Really Long Text..."  #This ensures the blur event happens
      page.should have_content("Course")
    end
    it "always fails" do
     #1.should eq(2)
    end
  end
end