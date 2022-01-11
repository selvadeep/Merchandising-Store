class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy]  
  def index
    @products = Product.all
      if @products.present?
        render json: {
            products: @products,
            message: 'List of products'
        }, status: :ok
      else
        render json: {
          errors: [
            { message: 'No Product Found' },
          ]
        }, status: :ok
      end 
  end

  def new
    @product = Product.new
  end

  def create
    begin
      @product = Product.create!(product_params)
        render json: {
            product: @product,
            message: 'Product created successfully by user.'
        }, status: :ok
    rescue Exception => e
       render json: {
          errors: [
            { message: e.message},
          ]
        }, status: :ok      
    end    
  end

  def show
  end

  def edit
  end

  def update
    if @product.present? && @product.update(update_product_params)
      render json: {
          product: @product,
          message: 'Product updated successfully by user.'
      }, status: :ok
    else
      render json: {
        errors: [
          { message: 'No Product updated' },
        ]
      }, status: :ok
    end
  end

  def destroy
    @product.destroy
    redirect_to products_path
  end

  def search
    @products = Product.where('name like ? or code like ?',"%#{params[:name_or_code]}%","%#{params[:name_or_code]}%")
      if @products.present?
        render json: {
            products: @products,
            message: 'List of products matched with search'
        }, status: :ok
      else
        render json: {
          errors: [
            { message: 'No Product Found' },
          ]
        }, status: :ok
      end  
  end

  def items_price
    product_codes = params[:product_codes].map{|h| h.keys.first }
    @products = Product.where(code: product_codes)
      if @products.present?
        items=[]
        total_price=0
        params[:product_codes].each do |h|
        p = Product.find_by_code h.keys.first
        qty = h.values.first
        if p.present? && qty.present?
        items << [p.name, qty]
        total_price+=(qty*p.price)
        end
        end        
        render json: {
            Items: items.map(&:first),
            Total: total_price.to_f
        }, status: :ok
      else
        render json: {
          errors: [
            { message: 'No Product Found' },
          ]
        }, status: :ok
      end    

  end

  def items_discounted_price
    prod_codes={};params[:product_codes].map{|h| k = h.keys.first; v = h.values.first; (prod_codes.keys.exclude?(k)? prod_codes[k]= v : (t=prod_codes[k]+v; prod_codes[k]= t))};prod_codes    
    @products = Product.where(code: prod_codes.keys)
    if @products.present?
      items=[]
      total_price=0      
      prod_codes.each do |k,v|
        p = Product.find_by_code k
        qty = v
        items << [p.name, qty]
        if p.present? && qty.present? && p.discount.present?
          d = p.discount
            if d.discount_type == "BOGO"
              if qty > 1 && d.discount_amount == 2 && d.free_item_count == 1
                qty = qty.even? ? (qty/2 ) : ((qty/2 )+1)
                total_price+=(qty*p.price)
              else
                total_price+=(qty*p.price)
              end
            elsif d.discount_type == "Percentage discount"
              if qty > 2 && d.discount_amount == 30
                total_price+=(((p.price*qty)*70)/100)
              else
                total_price+=(qty*p.price)
              end
            else
              total_price+=(qty*p.price)
            end
        elsif p.present? && qty.present?
          items << [p.name, qty]
          total_price+=(qty*p.price)
        end
      end
      render json: {
      Items: items.map(&:first),
      Total: total_price.to_f
      }, status: :ok
    else
      render json: {
      errors: [
      { message: 'No Product Found' },
      ]
      }, status: :ok
    end
  end

  private
    def product_params
      params.require(:product).permit(:name, :code, :price)
    end

    def update_product_params
      params.require(:product).permit(:price)
    end

    def set_product
      @product = Product.find_by_id(params[:id])
    end    
end
