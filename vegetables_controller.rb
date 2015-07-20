class VegetablesController < ApplicationController

  #line 4 should be Vegetable because the object/model we are rounding up is named Vegetable, not VEGETABLES
  def index
    @vegetables = Vegetable.all
  end

  def show
    @vegetable = Vegetable.find(params[:id])
  end

  def new
    @vegetable = Vegetable.new
  end

  def create
    @vegetable = Vegetable.new(whitelisted_vegetable_params)
    if @vegetable.save
      flash[:success] = "That sounds like a tasty vegetable!"
      redirect_to @vegetable
    end
    # dont need redirect that would require an entirely new HTTP request. And our instance vars would be wiped out. We can just rerender the view of another controller action with info already populated.
    render :new
  end

  def edit
    #Dont need to whitelist the params[:id] because id is a scalar parameter and cant put mailicious code in an integer. Whitlisting only applies to more complex parameters like hashes and arrays.
    @vegetable = Vegetable.find(params[:id])
  end

  def update
    #Dont need to create a new vegetable that would create a new vegetable, so we need to find the vegetable a user wants to edit
    # and we need to use the method update on it inorder to pass it the new params a user has specified on the form/edit page
    @vegetable = Vegetable.find(params[:id])
    vegetable.update(whitelisted_vegetable_params)
    if @vegetable.update
      flash[:success] = "A new twist on an old favorite!"
      redirect_to @vegetable
    else
      #want flash.now instead of flash because we are rendering a view instead of sending a request and flash would show up a page late since flash is designed to travel with a HTTP request
      flash.now[:error] = "Something is rotten here..."
      render :edit
    end
  end

  def delete
    @vegetable = Vegetable.find(params[:id])
    @vegetable.destroy
    flash[:success] = "That veggie is trashed."
    #cant redirect to an object that no longer exist. Should probably go back to the home page or index
    redirect_to vegetables_path
  end

  private

  #line 51 needs params in front because you are 'requiring' vegetables to be in params and then you permit the individual attributes inside that hash to be used. 
  def whitelisted_vegetable_params
    params.require(:vegetable).permit(:name, :color, :rating, :latin_name)
  end

end
