class PriceCheck < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.price_check.update_price.subject
  #
  def update_price(list,new_price)
  	#binding.pry
    @greeting = "Hi",
    @price = list.price,
    @item = list.title,
    @image = list.image,
    @new = new_price,
    @url = list.url

    mail(to: list.email)
  end

  def initial_price(list)
    #binding.pry
    @greeting = "Hi",
    @price = list.price,
    @item = list.title,
    @image = list.image,
    @url = list.url

    mail(to: list.email)
  end
end
