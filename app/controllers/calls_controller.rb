class CallsController < ApplicationController

  require 'vacuum'

  def index
    @list = List.all
  end

  def charts
      id = params[:id]
      @list = List.find(id)
      render :json => {
      :prices => @list.lprices,
      :list => @list
     }

  end

  def results
     @list = List.all
     @get = Call.get_items(params[:title])
     render :json => {
        :x => @get[1],
        :as => @get[0],
        :list => @list
     }

  end

end
