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

  # GET /lists/1
  # GET /lists/1.json
  def show
    render json: @list, status: :ok
  end

  # # GET /lists/new
  # def new
  #   @list = List.new
  # end

  # # GET /lists/1/edit
  # def edit
  # end

  # POST /lists
  # POST /lists.json
  def create

    @list = List.new(list_params)
    #binding.pry
    #p "delivering it"
    #binding.pry
    #PriceCheck.initial_price(@list).deliver_now


    if @list.save
      render json: @list, status: :created
    else
      render json: @list.errors, status: :unprocessable_entity

    end
  end

  # PATCH/PUT /lists/1
  # PATCH/PUT /lists/1.json
  def update
    if @list.update(list_params)
      render json: @list, status: :created
    else
      render json: @list.errors, status: :unprocessable_entity
    end
  end



  def info

    asin = params[:asin]

    a = Float(asin[0]) rescue false
    #binding.pry

    #check if its an ebay ID or an amazon ID (amazon ids start with a letter, ebay with a number)
    #ebay single item lookup
    if a.class == Float

      @x = Typhoeus.get("http://open.api.ebay.com/shopping?callname=GetSingleItem&responseencoding=JSON&appid=" + ENV["APPID"] + "&siteid=0&version=515&ItemID=" + asin, followlocation: true)
      @x = JSON.parse(@x.body)

      render :json => {
        :ebay => @x,
      }

    else

      p "not!!!"

      req = Vacuum.new

      req.configure(
        aws_access_key_id: ENV["AWSKEY"],
        aws_secret_access_key: ENV["AWSSECRET"],
        associate_tag: 'tag'
      )

      res = req.item_lookup(
        query: {
          'ItemId' => asin,
          'ResponseGroup' => 'Medium',
      })

      @z = res.to_h

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
    params.require(:list).permit(:title,:date,:item,:freq,:price,:asin,:email,:image,:last_price,:api)
  end
end
