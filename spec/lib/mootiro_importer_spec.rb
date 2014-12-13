require 'spec_helper'

describe MootiroImporter do
  describe "#wkt_with_reversed_coords" do
    let(:wkt)     { "GEOMETRYCOLLECTION (POINT (-46.747319110450746 -23.56587791267138))" }
    let(:wkt_rev) { "GEOMETRYCOLLECTION (POINT (-23.56587791267138 -46.747319110450746))" }
    it { expect(MootiroImporter::wkt_with_reversed_coords wkt_rev).to eq wkt }
  end

  describe "#remove_geometrycollection" do
    let(:point_collection) { "GEOMETRYCOLLECTION (POINT (-23.01 -46.02))" }
    let(:point)            { "POINT (-23.01 -46.02)" }
    let(:multi_collection) { "GEOMETRYCOLLECTION (POINT (-23.01 -46.02), POINT (-26.01 -43.02))" }
    let(:multipoint)       { "MULTIPOINT ((-23.01 -46.02), (-26.01 -43.02))" }

    it "does nothing if the geometry isn't a geometry collection" do
      expect(MootiroImporter::remove_geometrycollection point).to eq point
    end
    it "extracts geometry from geometry collection if there is only one geometry" do
      expect(MootiroImporter::remove_geometrycollection point_collection).to eq point
    end
    it "converts collection of points into multipoint" do
     expect(MootiroImporter::remove_geometrycollection multi_collection).to eq multipoint
    end
  end

  describe "#parse_geometry" do
    let(:in_)  { { geometry: "MULTIPOINT ((-23.01 -46.02), (-26.02 -43.03))" } }
    let(:out_) { "SRID=4326;MULTIPOINT ((-23.01 -46.02), (-26.02 -43.03))" }

    it { expect(MootiroImporter::parse_geometry in_).to eq out_ }
  end

  describe "#build_user" do
    let(:in_)  { {
      name: 'Joe',
      email: 'me@here.com',
      about_me: '<em>about</em>',
      crypted_password: 'cryptedpass',
      created_at: '2014-12-13',
      is_active: true,
      contacts: {email: 'me@here.com'},
      language: 'pt-br',
      geometry: "MULTIPOINT ((-23.01 -46.02), (-26.02 -43.03))"
    } }
    let(:out_) { {
      name: 'Joe',
      email: 'me@here.com',
      about_me: "<p><em>about</em></p>\n",
      crypted_password: 'cryptedpass',
      created_at: '2014-12-13T00:00:00.000Z',
      activation_state: 'active',
      contacts: {email: 'me@here.com'},
      language: 'pt-BR',
      location: "MULTIPOINT ((-46.02 -23.01), (-43.03 -26.02))",
      id: nil,
      avatar: {
        url: '/assets/imgs/avatar-placeholder.png',
        thumb: {
          url: '/assets/imgs/avatar-placeholder.png'
        }
      }
    } }

    it "creates user" do
      expect(MootiroImporter::build_user in_).to eq true
      expect(User.select([:name, :email, :about_me, :crypted_password, :created_at,
        :activation_state, :contacts, :language, :location]).where(email: 'me@here.com').first.to_json).to eq out_.to_json
    end
  end

  describe "#build_geo_data" do
    let(:in_)  { {
      name: 'Data',
      creator: 1,
      description: '<em>about</em>',
      short_description: 'mini about',
      created_at: '2014-12-13',
      contacts: {email: 'me@here.com'},
      tags: ['tagA', 'tagB'],
      geometry: "MULTIPOINT ((-23.01 -46.02), (-26.02 -43.03))"
    } }
    let(:out_) { {
      name: 'Data',
      description: "<p><em>about</em></p>\n",
      created_at: '2014-12-13T00:00:00.000Z',
      contacts: {email: 'me@here.com'},
      tags: ['tagA', 'tagB'],
      location: "MULTIPOINT ((-46.02 -23.01), (-43.03 -26.02))",
      additional_info: {
        short_description: "mini about",
        creator: 1
      },
      id: nil
    } }

    it "creates geo_data" do
      expect(MootiroImporter::build_geo_data in_).to eq true
      expect(GeoData.select([:name, :description, :created_at, :contacts, :tags,
        :location, :additional_info]).where(name: 'Data').first.to_json).to eq out_.to_json
    end
  end
end
