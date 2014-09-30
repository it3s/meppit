class Import < ActiveRecord::Base
  mount_uploader :source, ImportUploader
  process_in_background :source

  belongs_to :user
  belongs_to :project

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
