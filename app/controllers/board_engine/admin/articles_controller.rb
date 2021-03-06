# encoding: utf-8

class BoardEngine::Admin::ArticlesController < BoardEngine::Admin::AdminsController
	before_filter :require_user, :only => [:new, :edit, :create, :update, :destroy]
	before_filter :find_board

	def index
		@articles = @board.articles.order("created_at DESC").page(params[:page]).per(15)
	end

	def show
		@article = BoardEngine::Article.find params[:id]
	end

	def new
		@article = BoardEngine::Article.new
		@article.board_id = @board.id
	end

	def edit
		@article = @board.articles.find params[:id]
	end

	def create
		@article = @board.articles.build params[:article]
		@article.user_id = current_user.id
		if @article.save
			redirect_to admin_article_path(@board.title, @article)
		else
			render :action => "new"
		end
	end

	def update
		@article = @board.articles.find params[:id]
		if @article.update_attributes params[:article]
			redirect_to admin_article_path(@board.title, @article)
		else
			render :action => "edit"
		end
	end

	def destroy
		@article = @board.articles.where(id: params[:id]).first
		@article.destroy
		redirect_to admin_articles_path(@board.title)
	end

	private

	def find_board
		@board = BoardEngine::Board.find_by_title(params[:board_title])
	end

	# board type에 따라 다른 template을 render (AbstractController::Rendering#_process_options)
	def _process_options(options)
		options[:prefixes] << "board_engine/admin/articles/type_#{@board.board_type}"
	end
end

