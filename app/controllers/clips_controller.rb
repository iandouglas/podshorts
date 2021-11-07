class ClipsController < ApplicationController
    def index
        @clips = Clip.all
    end

    def edit
        @clip = Clip.find(params[:id])

        



        # if @clip

        # else 
        #     # set error
        #     rediect_to root_path
        # end
    end
end
