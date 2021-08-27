class Api::V1::BooksController < Api::V1::ApiController

  before_action :set_book, only: [ :show, :update, :destroy]
  before_action :authorize_request

  # GET /api
  def index
    @books = current_user.books
    render json: @books
  end

  def create
    @book = current_user.books.build(book_params)

    if @book.save
      render json: @book, status: :created
    else
      render json: @book.errors, status: :unprocessable_entity
    end
  end

  def show
    render json: @book
  end

  def update
    if @book.update(book_params)
      render json: @book
    else
      render json: @book.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @book.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_book
      @book = Book.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def book_params
      params.require(:book).permit(:name, :author, :genre, :rating, :feedback, :user_id)
    end

end
