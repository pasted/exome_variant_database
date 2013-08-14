class VariantsController < ApplicationController
  # GET /variants
  # GET /variants.json
  def index
    if !params[:q]
      params[:q] = {:order => "descend_by_id"}	
    end
    
    #pass the search params to a variable so it can be echoed in the search summary
    @search_params = params[:q]
    #call the search scopes on the Variants
    @search = Variant.search(params[:q])
    
    @variants = @search.result.page(params[:page]).per(20)
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @variants }
    end
  end

  # GET /variants/1
  # GET /variants/1.json
  def show
    @variant = Variant.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @variant }
    end
  end

  # GET /variants/new
  # GET /variants/new.json
  def new
    @variant = Variant.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @variant }
    end
  end

  # GET /variants/1/edit
  def edit
    @variant = Variant.find(params[:id])
  end

  # POST /variants
  # POST /variants.json
  def create
    @variant = Variant.new(params[:variant])

    respond_to do |format|
      if @variant.save
        format.html { redirect_to @variant, notice: 'Variant was successfully created.' }
        format.json { render json: @variant, status: :created, location: @variant }
      else
        format.html { render action: "new" }
        format.json { render json: @variant.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /variants/1
  # PUT /variants/1.json
  def update
    @variant = Variant.find(params[:id])

    respond_to do |format|
      if @variant.update_attributes(params[:variant])
        format.html { redirect_to @variant, notice: 'Variant was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @variant.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /variants/1
  # DELETE /variants/1.json
  def destroy
    @variant = Variant.find(params[:id])
    @variant.destroy

    respond_to do |format|
      format.html { redirect_to variants_url }
      format.json { head :no_content }
    end
  end
  
  def query_biomart
    if params[:id]
      @variant = Variant.find(params[:id])
      @gene = Gene.new
      response = @gene.query_biomart(@variant.location.chromosome.name, @variant.location.position_start)
     # if !(@gene = Gene.find_by_ensembl_gene_id(response[:data][0][1]))
        @gene.build_gene(response)      
     # end
    end
    
    respond_to do |format|
      format.html { redirect_to variants_url }
      format.json { head :no_content }
    end
  end
end