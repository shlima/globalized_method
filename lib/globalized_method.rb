# frozen_string_literal: true

require 'globalized_method/version'
require 'active_support/concern'

module GlobalizedMethod
  extend ActiveSupport::Concern

  class_methods do
    #  # @return [Symbol] localized method name
    def global_ln(prefix)
      "#{prefix}_#{I18n.locale}".to_sym
    end

    # @return [Array<Symbol>] all available methods for the prefix
    # @example i18n_ls("name") => [:name_et, :name_ru]
    # @example i18n_ls("name", code: true) => [[:name_et, :et], [:name_ru, :ru]]
    def global_ls(prefix, code: false)
      I18n.available_locales.map do |locale|
        method_name = "#{prefix}_#{locale}".to_sym
        code ? [method_name, locale] : method_name
      end
    end

    def globalized_method(prefix)
      class_eval <<~METHODS, __FILE__, __LINE__ + 1
        def #{prefix}
          public_send("#{prefix}_" + I18n.locale.to_s)
        end
      METHODS
    end
  end
end
