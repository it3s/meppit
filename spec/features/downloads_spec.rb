require 'spec_helper'

feature "DownloadsController" do
  feature "export" do
    given(:geo_data) { FactoryGirl.create :geo_data }
    given(:map) { FactoryGirl.create :map }

    background { visit polymorphic_path([:export, object], format: format) }

    shared_examples_for "download_resource" do
      scenario "downloads json file" do
        expect(page.status_code).to eq 200
        expect(page.body).to eq object.serialized_as(format)
        expect(page.response_headers["Content-Disposition"]).to eq "attachment; filename=\"#{obj_name}_#{object.id}.#{format}\""
        expect(page.response_headers["Content-Transfer-Encoding"]).to eq "binary"
        expect(page.response_headers["Content-Type"]).to eq(format == :csv ? "text/csv" : "application/#{format}")
      end
    end

    shared_examples_for "download file for each format" do
      context "json" do
        given(:format) { :json }
        it_behaves_like "download_resource"
      end

      context "geojson" do
        given(:format) { :geojson }
        it_behaves_like "download_resource"
      end

      context "xml" do
        given(:format) { :xml }
        it_behaves_like "download_resource"
      end

      context "csv" do
        given(:format) { :csv }
        it_behaves_like "download_resource"
      end
    end

    context "geo_data" do
      given(:object) { geo_data }
      given(:obj_name) { 'geo_data' }

      it_behaves_like "download file for each format"
    end

    context "maps" do
      given(:object) { map }
      given(:obj_name) { 'map' }

      it_behaves_like "download file for each format"
    end
  end

  feature "bulk_export" do
    given(:geo_data) { FactoryGirl.create :geo_data }
    given(:map) { FactoryGirl.create :map }

    background { visit polymorphic_path([:bulk_export, url_name], format: format, objects_ids: ids.join(',')) }

    shared_examples_for "download_resources" do
      scenario "downloads json file" do
        expect(page.status_code).to eq 200
        expect(page.body).to eq model.serialized_as(format, ids)
        expect(page.response_headers["Content-Disposition"]).to eq "attachment; filename=\"#{fname}.#{format}\""
        expect(page.response_headers["Content-Transfer-Encoding"]).to eq "binary"
        expect(page.response_headers["Content-Type"]).to eq(format == :csv ? "text/csv" : "application/#{format}")
      end
    end

    shared_examples_for "download model-wise file for each format" do
      context "json" do
        given(:format) { :json }
        it_behaves_like "download_resources"
      end

      context "geojson" do
        given(:format) { :geojson }
        it_behaves_like "download_resources"
      end

      context "xml" do
        given(:format) { :xml }
        it_behaves_like "download_resources"
      end

      context "csv" do
        given(:format) { :csv }
        it_behaves_like "download_resources"
      end
    end

    context "geo_data" do
      given(:model) { GeoData }
      given(:ids) { [geo_data.id] }
      given(:fname) { 'geo_data' }
      given(:url_name) { 'geo_data_index' }

      it_behaves_like "download model-wise file for each format"
    end

    context "maps" do
      given(:model) { Map }
      given(:ids) { [map.id] }
      given(:fname) { 'map' }
      given(:url_name) { 'maps' }

      it_behaves_like "download model-wise file for each format"
    end
  end
end
