class StoresController < ApplicationController
  def index
    @page = params[:page]
    @page = 1 if @page.blank?
    options = {:page => @page}
    conditions = {}
    if not params[:store_type].blank?
      conditions.merge!(:store_type => params[:store_type])
    end
    options.merge!(:conditions => conditions)
    session[:store_index] = options
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
  end

  def update
    @store = Store.find_by_id(params[:id])
    if @store.update_attributes(params[:store])
      flash[:updated_item] = params[:id]
      options = session[:store_index]
      if options and options.key?(:page)
        redirect_to stores_path(:page => options[:page])
      else
        redirect_to stores_path
      end
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
