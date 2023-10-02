require 'rails_helper'

RSpec.describe "TweetsBookmarks", type: :request do
  describe "POST /tweets/:id/bookmarks" do
    let(:user) { FactoryBot.create(:user) }
    let(:tweet) {FactoryBot.create(:tweet)}
    it "creates a new bookmark f0r a tweet" do
    

     # post tweet_bookmarks_path(tweet_id: tweet.id)
     # post "/tweets/#{tweet.id}/bookmarks", params: { user_id: user.id }
     post "/tweets/#{tweet.id}/bookmarks", params: { user_id: user.id }
     puts "holaaa"
     puts response.body
     expect(response).to have_http_status(201)
    expect(response).to match_response_schema("bookmark")
    end
  end

  describe "DELETE /tweets/:id/bookmarks" do
    let(:user) { FactoryBot.create(:user) }
    let(:tweet) { FactoryBot.create(:tweet) }
    let(:bookmark) { FactoryBot.create(:bookmark, user: user, tweet: tweet) }
    it "destroys an existing bookmark for a tweet" do
      puts bookmark.id
      delete "/tweets/#{tweet.id}/bookmarks/#{bookmark.id}"
  
      expect(response).to have_http_status(200)
    end
  end
  
end
