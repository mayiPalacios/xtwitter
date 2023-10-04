class Api::AuthenticationController < ApiController
skip_before_action :authenticate_user!  

  def create
        user = User.find_by(id: params[:id])
        if user.valid_password? params[:password]
          render json: {token: JsonWebToken.encode(sub: user.id)}
        else
            render json: { errors: ["Invalid email or password"]}              
        end
   end

end

