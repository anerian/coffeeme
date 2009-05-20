class StoresController < ApplicationController
  def index
    @page = params[:page]
    @page = 1 if @page.blank?
    options = {:page => @page}
    @stores = Store.paginate(:all, options)
  end

  def show
    @store = Store.find_by_id(params[:id])
  end

  def new
    @store = Store.new
  end

  def create
    @store = Store.new(params[:store])
    if @store.save
      redirect_to edit_store_path(@store)
    else
      render :new
    end
  end

  def edit
    @store = Store.find_by_id(params[:id])
    @page = params[:page]
  end

  def update
    @store = Store.find_by_id(params[:id])
    @page = params[:page]
    if @store.update_attributes(params[:store])
      redirect_to stores_path(:page => params[:page], :updated_item => params[:id])
    else
      render :edit
    end
  end

  def delete
    @store = Store.find_by_id(params[:id])
  end

  def destroy
    @store = Store.find_by_id(params[:id])
    # TODO
  end

end
