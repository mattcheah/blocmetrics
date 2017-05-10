class RegisteredApplicationsController < ApplicationController
    
    before_action :authenticate_user!, except: [:index]
    before_action :confirm_owner, except: [:index, :new, :create]
    
    def index
        if current_user
            @apps = RegisteredApplication.where({user_id: current_user.id})
        end
    end
    
    def show
        @app = RegisteredApplication.find(params[:id])
        @events = @app.events.group_by(&:name)
    end
    
    def setup
        @app = RegisteredApplication.find(params[:id])
    end
    
    def new
        @app = RegisteredApplication.new
    end
    
    def create
        name = params[:registered_application][:name]
        url = params[:registered_application][:url]
        @app = current_user.registered_applications.new({name: name, url: url, code: rand(10000)})
        
        if @app.save
            flash[:success] = "Registered Application #{@app.name} has been created"
            redirect_to registered_application_path(@app.id)
        else 
            flash[:danger].now = "Registered Application #{@app.name} could not be created. Please try again"
            render_template :new
        end
            
    end
    
    def edit
        @app = RegisteredApplication.find(params[:id])
    end
    
    def update 
        @app = RegisteredApplication.find(params[:id])
        @app.name = params[:registered_application][:name]
        @app.url = params[:registered_application][:url]
        
        if @app.save
            flash[:success] = "Registered Application #{@app.name} has been updated"
            redirect_to registered_application_path
        else 
            flash[:danger].now = "Registered Application #{@app.name} could not be updated. Please try again"
            render_template :edit
        end 
        
    end
    
    def destroy
        @app = RegisteredApplication.find(params[:id])
        name = @app.name
        if @app.destroy
            flash[:success] = "Registered Application #{name} has been deleted"
            redirect_to registered_applications_path
        else 
            flash[:danger].now = "Registered Application  #{name} could not be deleted. Please try again"
            render_template :edit
        end 
    end
    
    private
    
    def confirm_owner
        unless current_user && current_user.registered_applications.all.include?(RegisteredApplication.find(params[:id]))
            flash[:warning] = "You are not authorized to do that!"
            redirect_to registered_applications_path
        end
    end
    
end
