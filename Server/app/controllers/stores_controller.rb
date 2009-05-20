class StoresController < ApplicationController
  def index
    @page = params[:page]
    @page = 1 if @page.blank?
    options = {:page => @page}
    conditions = {}
    if not params[:store_type].blank?
      conditions.merge!(:store_type => params[:store_type])
    end
    if not params[:filter].blank?
      options.merge!(:filter => params[:filter])
    end
    options.merge!(:conditions => conditions)
    session[:store_index] = options.clone
    logger.debug("store_index with: #{options.inspect}")
    filter = options.delete(:filter)
    if filter
      values = []
      conditions = options.delete(:conditions).map{|k,v| values << v; "#{k}=?" }.join(' ')
      conditions << " AND " if not conditions.blank?
      conditions << " (street LIKE ? OR city LIKE ? OR state LIKE ? OR phone LIKE ?)"
      4.times { values << "%#{filter}%" }
      conditions = [conditions] + values
      logger.debug("filters: #{conditions.inspect}")
      options.merge!(:conditions => conditions)
      @stores = Store.paginate(:all, options)
    else
      @stores = Store.paginate(:all, options)
    end
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
      if options and (options.key?(:page) or options.key?(:filter))
        logger.debug("redirect with options: #{options.inspect}")
        redirect_to stores_path(:page => options[:page], :filter => options[:filter])
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
