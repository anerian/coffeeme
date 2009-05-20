class DrinksController < ApplicationController
  def index
    @page = params[:page]
    @page = 1 if @page.blank?
    options = {:page => @page}
    session[:drink_index] = options
    @drinks = Drink.paginate(:all, options)
  end

  def show
    @drink = Drink.find_by_id(params[:id])
  end

  def new
    @drink = Drink.new
  end

  def create
    @drink = Drink.new(params[:drink])
    if @drink.save
      redirect_to edit_drink_path(@drink)
    else
      render :new
    end
  end

  def edit
    @drink = Drink.find_by_id(params[:id])
    @page = params[:page]
  end

  def update
    @drink = Drink.find_by_id(params[:id])
    @page = params[:page]
    if @drink.update_attributes(params[:drink])
      flash[:updated_item] = params[:id]
      options = session[:drink_index]
      if options and options.key?(:page)
        redirect_to drinks_path(:page => options[:page])
      else
        redirect_to drinks_path
      end
    else
      render :edit
    end
  end

  def delete
    @drink = Drink.find_by_id(params[:id])
  end

  def destroy
    @drink = Drink.find_by_id(params[:id])
  end

end
