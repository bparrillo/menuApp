class MenuItemsController < ApplicationController
  before_action :set_menu_item, only: %i[show edit update destroy]
  before_action :authenticate_user!, only: %i[new create edit update destroy]

  # GET /menu_items
  # GET /menu_items.json
  def index
    @menu_items = MenuItem.all
  end

  def submit_order
    @menu_items = MenuItem.all
  end

  def confirm_order
    @sum = 0
    @menu_vals = params.permit(params.keys).to_h.select { |key, _value| key.to_i.to_s == key }
    @menu_vals.each do |key, val|
      @sum += ((BigDecimal.new(MenuItem.find(key.to_i).price, 4) * val.to_f).to_f* 100).round / 100.0
    end
  end

  def tip
    @sum = 0
    @menu_vals = params[:order].permit(params[:order].keys).to_h.select { |key, _value| key.to_i.to_s == key }
    @menu_vals.each do |key, val|
      @sum += (BigDecimal.new(MenuItem.find(key.to_i).price, 4) * val.to_f).to_f
    end
    @sum = ((@sum * (1 + BigDecimal.new(params[:tip]))).to_f * 100).round / 100.0
    @tip = params[:tip]
  end

  def finalize_order
    @order = Order.new

    params[:order].permit(params[:order].keys).to_h.each do |key, _val|
      @order.menu_items << MenuItem.find(key.to_i)
    end
    @order.tip = params[:tip]
    if @order.save
      params[:order].permit(params[:order].keys).to_h.each do |key, val|
        OrderItem.find_by(menu_item_id: key.to_i).update!(number: val.to_i)
      end
      @menu_items = MenuItem.all
      render :submit_order, notice: 'Order successfully created.'
    else
      @menu_items = MenuItem.all
      render :submit_order, notice: 'Order not created, error.'
    end
  end

  # GET /menu_items/1
  # GET /menu_items/1.json
  def show; end

  # GET /menu_items/new
  def new
    @menu_item = MenuItem.new
  end

  # GET /menu_items/1/edit
  def edit; end

  # POST /menu_items
  # POST /menu_items.json
  def create
    @menu_item = MenuItem.new(menu_item_params)

    respond_to do |format|
      if @menu_item.save
        format.html { redirect_to @menu_item, notice: 'Menu item was successfully created.' }
        format.json { render :show, status: :created, location: @menu_item }
      else
        format.html { render :new }
        format.json { render json: @menu_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /menu_items/1
  # PATCH/PUT /menu_items/1.json
  def update
    respond_to do |format|
      if @menu_item.update(menu_item_params)
        format.html { redirect_to @menu_item, notice: 'Menu item was successfully updated.' }
        format.json { render :show, status: :ok, location: @menu_item }
      else
        format.html { render :edit }
        format.json { render json: @menu_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /menu_items/1
  # DELETE /menu_items/1.json
  def destroy
    @menu_item.destroy
    respond_to do |format|
      format.html { redirect_to menu_items_url, notice: 'Menu item was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_menu_item
    @menu_item = MenuItem.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def menu_item_params
    params.require(:menu_item).permit(:name, :description, :price, :category)
  end
end
