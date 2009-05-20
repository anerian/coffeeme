class TriviasController < ApplicationController
  def index
    @page = params[:page]
    @page = 1 if @page.blank?
    options = {:page => @page}
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
    @page = params[:page]
  end

  def update
    @trivia = Trivia.find_by_id(params[:id])
    @page = params[:page]
    if @trivia.update_attributes(params[:trivia])
      redirect_to trivias_path(:page => @page, :updated_item => params[:id])
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
