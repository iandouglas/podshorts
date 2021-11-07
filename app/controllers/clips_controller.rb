class ClipsController < ApplicationController
    def index
        @clips = Clip.all
    end

    def edit
        @clip = Clip.find(params[:id])
    end

    def update
        clip = Clip.find(params[:id])
        clip.update(update_params)

        redirect_to root_path
    end

    def destroy
        Clip.destroy(params[:id])
        
        redirect_to root_path
    end

    private

    def update_params
        field_list = Clip.columns.map{|c| c.name.to_sym}
        field_list.shift
        params.require(:clip).permit(field_list)
    end
end
