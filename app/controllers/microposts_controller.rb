class MicropostsController < ApplicationController
    before_action :logged_in_user, only: [:create, :update, :destroy]
    before_action :correct_user,   only: :destroy
    def create
        # 現在のユーザーにmicropostsをリレーションを作成しながら、一旦型を作る。
        @micropost = current_user.microposts.build(micropost_params)
        @micropost.image.attach(params[:micropost][:image])
        if @micropost.save
            flash[:success] = "Micropost created!"
            redirect_to root_url
        else
            @feed_items = current_user.feed.paginate(page: params[:page])
            render 'static_pages/home', status: :unprocessable_entity
        end
    end
    def update
        # @micropost = Micropost.find(params:id)
        # # loginしている。
        # # activateされたuserである。
        # # micropostの投稿者が編集しようとしている。
    end

    def destroy
        @micropost.destroy
        flash[:success] = "Micropost deleted"
        if request.referrer.nil?
        redirect_to root_url, status: :see_other
        else
        redirect_to request.referrer, status: :see_other
        end
    end

    private
    # すトロングパラメーターの記述欄
    def micropost_params
        params.require(:micropost).permit(:content, :image)
    end
    
    def correct_user
        @micropost = current_user.microposts.find_by(id: params[:id])
        redirect_to root_url, status: :see_other if @micropost.nil?
    end
end
