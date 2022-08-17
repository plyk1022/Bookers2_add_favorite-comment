class BooksController < ApplicationController
  before_action :authenticate_user!
  before_action :specified_user, only: [:edit]
  

  def show
    @book = Book.new
    @selected_book = Book.find(params[:id])
    @user = User.find(@selected_book.user.id)
    @book_comment = BookComment.new
    @book_comments = BookComment.where(book_id: @selected_book.id)
  end

  def index
    @book = Book.new
    @books = Book.all
  end

  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    if @book.save
      redirect_to book_path(@book), notice: "You have created book successfully."
    else
      @books = Book.all
      render 'index'
    end
  end

  def edit
    @book = Book.find(params[:id])
  end

  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
      redirect_to book_path(@book), notice: "You have updated book successfully."
    else
      render "edit"
    end
  end

  def destroy
    @book = Book.find(params[:id])
    @book.destroy
    redirect_to books_path
  end
  
  def specified_user
    @user = Book.find(params[:id]).user
    redirect_to books_path unless @user.id == current_user.id
  end

  private

  def book_params
    params.require(:book).permit(:title, :body)
  end
end
