class API::EventsController < ApplicationController
    
    skip_before_action :verify_authenticity_token
    
    before_filter :set_access_control_headers
    
    def set_access_control_headers
        headers['Access-Control-Allow-Origin'] = '*'
        headers['Access-Control-Allow-Methods'] = 'POST, GET, OPTIONS'
        headers['Access-Control-Allow-Headers'] = 'Content-Type'
    end
    
    def preflight
        head 200
    end
    
    def create
        app = RegisteredApplication.find_by(url: request.env['HTTP_ORIGIN'])
        if app 
            name = event_params[:name]
            @event = Event.create({name: name, registered_application_id: app.id})
            if @event.save 
                render json: @event, status: :created
            else
                render json: {errors: @event.errors}, status: :unprocessable_entity
            end
        else 
            render json: "Unregistered Application", status: :unprocessable_entity
        end
        
    end
    
    private
    
    def event_params 
        params.require(:event).permit(:name)
    end
end
