class StaticPagesController < ApplicationController
  def home
  end

  def help
      @page_title = " | Help"
  end
  
  def about
      @page_title = " | About Us"
  end
  
  def contact
      @page_title = " | Contact"
  end
end
