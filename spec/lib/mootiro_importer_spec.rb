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
    let(:in_)  { { geometry: "GEOMETRYCOLLECTION (POINT (-46.02 -23.01), POINT (-43.02 -26.01))" } }
    let(:out_) { "MULTIPOINT ((-23.01 -46.02), (-26.01 -43.02))" }

    it { expect(MootiroImporter::parse_geometry in_).to eq out_ }
  end
end
