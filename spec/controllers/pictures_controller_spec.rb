require 'spec_helper'

describe PicturesController do
  let(:user) { FactoryGirl.create :user }
  let(:picture) { FactoryGirl.create :picture }
  let(:object) { picture.object }

  before { login_user user }

  describe 'GET show' do
    context "from show page" do
      before { request.env['HTTP_REFERER'] = controller.url_for(object) }

      it "assigns object and picture and render template" do
        get :show, {id: picture.id, geo_data_id: object.id}
        expect(assigns :object).to eq object
        expect(assigns :picture).to eq picture
        expect(assigns :edit_enabled).to eq false
        expect(response).to render_template :show
      end
    end

    context "from edit page" do
      before { request.env['HTTP_REFERER'] = controller.url_for([:edit, object]) }

      it "assigns object and picture and render template" do
        get :show, {id: picture.id, geo_data_id: object.id}
        expect(assigns :object).to eq object
        expect(assigns :picture).to eq picture
        expect(assigns :edit_enabled).to eq true
        expect(response).to render_template :show
      end
    end
  end

  describe "PATCH upload" do
    let(:geo_data) { FactoryGirl.create :geo_data }
    let(:file) { File.join(Rails.root, 'app', 'assets', 'images', 'imgs', 'avatar-placeholder.png') }
    let(:blank_msg) { controller.t 'activerecord.errors.messages.blank' }

    context 'valid' do
      it "creates a picture for the object" do
        expect(geo_data.pictures.count).to eq 0
        patch :upload, {picture: Rack::Test::UploadedFile.new(file), id: geo_data.id }
        expect(response.status).to eq 200
        expect(geo_data.pictures.count).to eq 1
        expect(geo_data.pictures.first.author).to eq user
      end
    end

    context 'invalid' do
      it "creates a picture for the object" do
        expect(geo_data.pictures.count).to eq 0
        patch :upload, {id: geo_data.id }
        expect(response.status).to eq 422
        expect(response.body).to eq({errors: {image: [blank_msg]}}.to_json)
      end
    end
  end
end
