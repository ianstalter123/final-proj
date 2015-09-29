class ListsController < ApplicationController

  #seperate the get functionality into a different
  #controller
  #get the search working correctly with input item
  #limit the number of items returned on search
  before_action :set_list, only: [:show, :edit, :update, :destroy]

  # GET /lists
  # GET /lists.json
  def index
    @lists = List.all

    render :json => {
      :lists => @lists
    }
    CallsWorker.perform_async()
  end

  def show
    render json: @list, status: :ok
  end

  def create

    @list = List.new(list_params)
    #binding.pry
    PriceCheck.initial_price(@list).deliver_now

    if @list.save
      render json: @list, status: :created
    else
      render json: @list.errors, status: :unprocessable_entity
    end
  end

  def update
    if @list.update(list_params)
      render json: @list, status: :created
    else
      render json: @list.errors, status: :unprocessable_entity
    end
  end



  def info

    asin = params[:asin]
    api = params[:api]


 #gets the ebay result for one item
    if api == "ebay"
      @x = Typhoeus.get("http://open.api.ebay.com/shopping?callname=GetSingleItem&responseencoding=JSON&appid=" + ENV["APPID"] + "&siteid=0&version=515&ItemID=" + asin, followlocation: true)
      @x = JSON.parse(@x.body)

      render :json => {
        :ebay => @x,
      }

    else

  #get_am is the function to get the amazon api call data for 1 item 
      @z = List.get_am(asin)
      render :json => {
        :z => @z,
      }
    end
  end

  # DELETE /lists/1
  # DELETE /lists/1.json
  def destroy
    @list.destroy
    render json: @list, status: ok
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_list
    @list = List.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def list_params
    params.require(:list).permit(:title,:date,:item,:freq,:price,:asin,:email,:image,:last_price,:api,:url,:avg)
  end
end
