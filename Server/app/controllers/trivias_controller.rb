class TriviasController < ApplicationController
  def index
    @page = params[:page]
    @page = 1 if @page.blank?
    options = {:page => @page}
    session[:trivia_index] = options
    @trivias = Trivia.paginate(:all, options)
  end

  def show
    @trivia = Trivia.find_by_id(params[:id])
  end

  def new
    @trivia = Trivia.new
  end

  def create
    @trivia = Trivia.new(params[:trivia])
    if @trivia.save
      redirect_to edit_trivia_path(@trivia)
    else
      render :new
    end
  end

  def edit
    @trivia = Trivia.find_by_id(params[:id])
  end

  def update
    @trivia = Trivia.find_by_id(params[:id])
    if @trivia.update_attributes(params[:trivia])
      flash[:updated_item] = params[:id]
      options = session[:trivia_index]
      if options and options.key?(:page)
        redirect_to trivias_path(:page => options[:page])
      else
        redirect_to trivias_path
      end
    else
      render :edit
    end
  end

  def delete
    @trivia = Trivia.find_by_id(params[:id])
  end

  def destroy
    @trivia = Trivia.find_by_id(params[:id])
  end

end
