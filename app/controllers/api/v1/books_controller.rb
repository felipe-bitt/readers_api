class Api::V1::BooksController < Api::V1::ApiController

  before_action :require_authorization!, only: [:show, :update, :destroy]


  # GET /api
  def index
    @books = Book.all
    render json: @books
  end

  def create
    @book = Book.new(book_params.merge(user: current_user))

    if @book.save
      render json: @book, status: :created
    else
      render json: @book.errors, status: :unprocessable_entity
    end
  end

  def show
    render json: @books
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
      params.require(:book).permit(:name, :author, :genre, :rating, :feedback)
    end

    def require_authorization!
      unless current_user == @current_user
        render json: {}, status: :forbidden
      end
    end

end
