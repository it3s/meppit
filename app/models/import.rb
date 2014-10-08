class Import < ActiveRecord::Base
  mount_uploader :source, ImportUploader
  process_in_background :source

  belongs_to :user
  belongs_to :map

  validates :source, presence: true
  validates :user,   presence: true

  def parse_source
    collection = []
    CSV.foreach(source.file.path, col_sep: ';', headers: :first_row) do |row|
      collection << OpenStruct.new(data: build_attrs(row), row: row)
    end
    collection
  end

  def self.csv_headers
    @csv_headers ||= [
      'name',
      'description',
      'tags',
      'contacts:phone',
      'contacts:email',
      'contacts:address',
      'contacts:city',
      'contacts:compl',
      'contacts:site',
      'contacts:other',
      'contacts:postal_code',
      'contacts:twitter',
      'contacts:facebook',
      'additional_info'
    ]
  end

  def load_to_map!(map_id)
    imported_data_ids = parse_source.map do |parsed|
      geo_data = GeoData.new parsed.data
      geo_data.save
      geo_data.mappings.create map_id: map_id
      geo_data.id
    end.compact

    if imported_data_ids.size > 0
      assign_attributes imported: true, imported_data_ids: imported_data_ids, map_id: map_id
      save
    else
      false
    end
  end

  def filename
    source.file.filename
  end

  private

    def build_attrs(row)
      {
        name: row['name'],
        description: row['description'],
        tags: row['tags'].split(',').map(&:strip),
        contacts: contacts_to_hash(row),
        additional_info: parse_yaml(row),
      }
    end

    def contacts_to_hash(row)
      contacts = {}
      [
        'phone', 'email', 'address', 'city', 'compl', 'site', 'other',
        'postal_code', 'twitter', 'facebook'
      ].each { |k| contacts[k.to_sym] = row["contacts:#{k}"] unless row["contacts:#{k}"].blank? }
      contacts
    end

    def parse_yaml(row)
      info = row['additional_info']
      (info && !info.empty?) ? SafeYAML.load(info, safe: true) : nil
    end
end
