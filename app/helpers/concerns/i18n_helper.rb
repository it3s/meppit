module Concerns
  module I18nHelper
    extend ActiveSupport::Concern

    def i18n_language_names
      {
        :en      => 'English',
        :'pt-BR' => 'Português'
      }
    end

    def current_translations
      I18n.backend.send(:init_translations) unless I18n.backend.initialized?
      @translations ||= I18n.backend.send(:translations)
      (@translations[I18n.locale] || {}).with_indifferent_access
    end

    def language_options
      I18n.available_locales.map { |lang| [i18n_language_names[lang], lang.to_s] }
    end
  end
end
