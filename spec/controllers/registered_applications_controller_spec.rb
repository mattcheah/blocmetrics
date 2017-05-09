require 'rails_helper'


RSpec.describe RegisteredApplicationsController, type: :controller do
    include Devise::Test::ControllerHelpers
    
    before(:each) do
        @user = create(:user)
        @user2 = create(:user, email: "user2@gmail.com")
        @app = @user.registered_applications.create!({name: "google.com", url: "google.com"})
        @app2 = @user2.registered_applications.create!({name: "yahoo", url: "yahoo.com"})
    end
    
    describe "GET index" do
    
        context "user logged out" do
            it "returns 200" do
                get :index
                expect(response).to have_http_status(200)
            end
            it "renders the index template" do
                get :index
                expect(response).to render_template(:index)
            end
        end
        
        context "user logged in" do
            before(:each) do
                sign_in @user 
            end
            it "returns 200" do
                get :index
                expect(response).to have_http_status(200)
            end
            
            it "renders the index template" do
                get :index
                expect(response).to render_template(:index)
            end
            
        end

    end   
    
    describe "GET show" do
    
        context "user logged out" do
            it "redirects the page" do
                get :show, { id: @app.id}
                expect(response).to have_http_status(:redirect)
            end
            it "redirects to the homepage" do
                get :show, id: @app.id
                expect(response).to redirect_to(new_user_session_path)
            end
        end
        
        context "user logged in" do
            before(:each) do
                sign_in @user
            end
            it "returns 200" do
                get :show, {id: @app.id}
                expect(response).to have_http_status(200)
            end
            
            it "renders the index template" do
                get :show, {id: @app.id}
                expect(response).to render_template(:show)
            end
            
            it "assigns the app to @app" do 
                get :show, {id: @app.id}
                expect(assigns(:app)).to eq(@app)
            end
            it "does not show an app that the user does not own" do
                get :show, {id: @app2.id}
                expect(response).to redirect_to(registered_applications_path)
            end
        end
    
    end
    
    describe "GET new" do
    
        context "user logged out" do
            it "redirects the page" do
                get :new
                expect(response).to have_http_status(:redirect)
            end
            it "redirects to the homepage" do
                get :new
                expect(response).to redirect_to("/users/sign_in")
            end
            
        end
        context "user logged in" do
            before(:each) do
                sign_in @user
            end
            it "returns 200" do
                get :new
                expect(response).to have_http_status(200)
            end
            
            it "renders the index template" do
                get :new
                expect(response).to render_template(:new)
            end
            
            it "assigns a new app to @app" do 
                get :new
                expect(assigns(:app)).to_not be_nil
            end
        end
    
    end
    
    describe "POST create" do
    
        context "user logged out" do
            it "redirects the page" do
                post :create, registered_application: {name: "Google", url: "google.com", user_id: @user.id}
                expect(response).to have_http_status(:redirect)
            end
            it "redirects to the homepage" do
                post :create, registered_application: {name: "Google", url: "google.com", user_id: @user.id}
                expect(response).to redirect_to("/users/sign_in")
            end
            it "does not increase the number of Registered Applications by 1" do 
                expect{
                    post :create, registered_application: {name: "Google", url: "google.com", user_id: @user.id}
                }.to change{RegisteredApplication.all.count}.by(0)
            end
        end
        
        context "user logged in" do
            before(:each) do
                sign_in @user
            end
            it "returns 200" do
                post :create, registered_application: {name: "Google", url: "google.com", user_id: @user.id}
                expect(response).to have_http_status(:redirect)
            end
            
            it "renders the show template" do
                post :create, registered_application: {name: "Google", url: "google.com", user_id: @user.id}
                expect(response).to redirect_to(registered_application_path(RegisteredApplication.last.id))
            end
            
            it "increases the number of Registered Applications by 1" do 
                expect{
                    post :create, registered_application: {name: "Google", url: "google.com", user_id: @user.id}
                }.to change{RegisteredApplication.all.count}.by(1)
            end
        end
    
    end
    
    describe "GET edit" do
       context "user logged out" do
            it "redirects the page" do
                get :edit, id: @app.id
                expect(response).to have_http_status(:redirect)
            end
            it "redirects to the homepage" do
                get :edit, id: @app.id
                expect(response).to redirect_to("/users/sign_in")
            end
        end
        context "user logged in" do
            before(:each) do
                sign_in @user
            end
            it "returns http success" do
                get :edit, id: @app.id
                expect(response).to have_http_status(:success)
            end
            it "renders the edit template" do
                get :edit, id: @app.id
                expect(response).to render_template(:edit)
            end
            it "assigns @app to @app" do
                get :edit, id: @app.id
                expect(assigns(:app)).to eq(@app)
            end
            it "does not allow user to edit an app that does not belong to them" do
                get :edit, id: @app2.id
                expect(response).to redirect_to(registered_applications_path)
            end
       end
    end
    
    describe "PUT update" do
        context "user logged out" do
            it "redirects the page" do
                put :update, id: @app.id, registered_application: {name: "yahoo", url: "yahoo.com", user_id: @user.id}
                expect(response).to have_http_status(:redirect)
            end
            it "redirects to the homepage" do
                put :update, id: @app.id, registered_application: {name: "yahoo", url: "yahoo.com", user_id: @user.id}
                expect(response).to redirect_to("/users/sign_in")
            end
            it "does not edit the app" do
                put :update, id: @app.id, registered_application: {name: "yahoo", url: "yahoo.com", user_id: @user.id}
                expect(RegisteredApplication.find(@app.id).name).to eq("google.com")
            end
        end
        context "user logged in" do
            before(:each) do
                sign_in @user
            end
            it "updates the item in the database" do
                put :update, id: @app.id, registered_application: {name: "yahoo", url: "yahoo.com", user_id: @user.id}
                expect(RegisteredApplication.find(@app.id).name).to eq("yahoo")
                expect(RegisteredApplication.find(@app.id).url).to eq("yahoo.com")
            end
            it "redirects to the show page" do
                put :update, id: @app.id, registered_application: {name: "yahoo", url: "yahoo.com", user_id: @user.id}
                expect(response).to redirect_to(registered_application_path)
            end
            it "redirects to a new page" do
                put :update, id: @app.id, registered_application: {name: "yahoo", url: "yahoo.com", user_id: @user.id}
                expect(response).to have_http_status(:redirect)
            end
            it "does not allow user to edit an app that does not belong to them" do
                put :update, id: @app2.id, registered_application: {name: "facebook", url: "facebook.com"}
                expect(response).to redirect_to(registered_applications_path)
                expect(response).to have_http_status(:redirect)
                expect(RegisteredApplication.find(@app2.id).name).to eq("yahoo")
                expect(RegisteredApplication.find(@app2.id).url).to eq("yahoo.com")
            end
            
        end
    end
    
    describe "DELETE Destroy" do
        context "user logged out" do
            
            it "redirects the page" do
                delete :destroy, id: @app.id
                expect(response).to have_http_status(:redirect)
            end
            it "redirects to the homepage" do
                delete :destroy, id: @app.id
                expect(response).to redirect_to("/users/sign_in")
            end
            it "does not destroy the app" do
                delete :destroy, id: @app.id
                expect(RegisteredApplication.where({id: @app.id}).count).to eq(1)
            end
        
        end
        context "user logged in" do
            before(:each) do
                sign_in @user
            end
            it "redirects the page" do
                delete :destroy, id: @app.id
                expect(response).to have_http_status(:redirect)
            end
            it "redirects to the index page" do
                delete :destroy, id: @app.id
                expect(response).to redirect_to(registered_applications_path)
            end
            it "deletes the record" do 
                delete :destroy, id: @app.id
                expect(RegisteredApplication.where({id: @app.id}).count).to eq(0)
            end
            it "does not allow a user that does not own the app to delete the record" do
                delete :destroy, id: @app2.id
                expect(response).to redirect_to(registered_applications_path)
                expect(RegisteredApplication.where({id: @app2.id}).count).to eq(1)
            end
        end
    end
end
