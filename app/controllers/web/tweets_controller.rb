class Web::TweetsController < ApplicationController
  include TweetStatsModule
  include CloudinaryMethod

    def create
        user_id = params[:user_id]
        body = params[:body]
        quote = params[:quote]
        retweet = params[:retweet]
        url_imagen = params[:photo_url]
        photo_url = nil
        if url_imagen!=nil
        photo_url =  upload(url_imagen)
        end

        @tweet = Tweet.new(user_id: user_id, body: body, quote: quote, retweet: retweet,photo_url: photo_url)
         
        
        
          if @tweet.save
            redirect_to web_tweets_path(user_id: user_id)
        
        end
 
    end

  


     def index 
      user = User.find(params[:user_id])
    
    
    
      following_ids = Follower.where(following_id: user.id).pluck(:followee_id)
      
     
      following_ids << user.id
      
      @tweets = Tweet.where(user_id: following_ids).order(created_at: :desc)
      
       render '/web/tweets/index' 
     
   end 
   
   
   before_action :set_tweet, only: [:update,:retweet]
   
   def update
         if @tweet.update(tweet_params)
            render json: { tweet: @tweet }, status: :ok
         else
            render json: { errors: @tweet.errors.full_messages }, status: :unprocessable_entity
         end
   end
 
 
   def quote 
     tweet_id = params[:id]  
     user_id = params[:user_id]
     body = params[:body]
     
     @tweet = Tweet.new(user_id: user_id, body: body, quote: true, retweet: false,interaction_reference: tweet_id)
     
     respond_to do |format|
           if @tweet.save
             format.json { render json: { tweet: @tweet }, status: :created }
          else
             format.json { render json: @tweet.errors, status: :unprocessable_entity }
          end
      end
  
   end
 


  def retweet
    tweet_id = params[:id]
    user_id = current_user.id
  
    if has_retweeted?(tweet_id, user_id)
      Tweet.where(user_id: user_id, interaction_reference: tweet_id, retweet: true).delete_all
      render json: { message: 'Retweet deshecho.' }, status: :ok
    else
      @tweet = Tweet.new(user_id: user_id, body: nil, quote: false, retweet: true, interaction_reference: tweet_id)
      
      if @tweet.save
        redirect_to web_user_by_username_path(username: current_user.username)
      end
    end
  end
  
  

   def show 
    @tweet = Tweet.find(params[:id])
    @replies = @tweet.replies
    render 'show'
        
   end
 
   

 
   private
 
   def set_tweet
     @tweet = Tweet.find(params[:id])
   end
 
   def tweet_params
     params.require(:tweet).permit(:body, :quote, :retweet)
   end
 
   def has_retweeted?(tweet_id,user_id)
    Tweet.where(retweet: true, interaction_reference: tweet_id, user_id: user_id).exists?
  end

  
end
