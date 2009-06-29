class ReportsController < ApplicationController
  def index
    @reports = Report.find(:all, :limit => 30, :order => 'date DESC').reverse
    @total_sales = Report.sum(:units)
    @sales_this_month = Report.sum(:units, :conditions => ['date > ?', 30.days.ago])
  end

  def show
  end

end
