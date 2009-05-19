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
  end

  def edit
    @store = Store.find_by_id(params[:id])
  end

  def update
    @store = Store.find_by_id(params[:id])
  end

  def delete
    @store = Store.find_by_id(params[:id])
  end

  def destroy
    @store = Store.find_by_id(params[:id])
  end

end
