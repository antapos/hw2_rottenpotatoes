class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @order = params[:order]
    @ratings = params[:ratings]
    if @order == nil && @ratings == nil && params[:commit] == nil && (session[:order] != nil || session[:ratings] != nil)
      @order = session[:order]
      @ratings = session[:ratings]
      redirect_to movies_path(:order => @order, :ratings => @ratings)
    else
      session[:order] = @order
      session[:ratings] = @ratings
      @movies = Movie.all :conditions => params[:ratings] != nil ? ["rating in (:ratings)", {:ratings => @ratings.keys}] : [], :order => @order
      @all_ratings = Movie.all_ratings
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
