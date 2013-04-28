module Translator
  class << self
    def fallback_locale  ()        @fallback_locale  ||= nil         end
    def fallback_locale= (locale)  @fallback_locale    = locale.to_s end
    def prefixed_locales ()        @prefixed_locales ||= []          end
    def prefixed_locales=(locales) @prefixed_locales   = locales     end

    def prefixed name
      if prefixed_locales.empty?
        name.to_sym
      else
        prefixed_locales.map do |locale|
          "#{locale}_#{name}".to_sym
        end
      end
    end
  end

  module Translates
    extend ActiveSupport::Concern

    included do
      def translate name, translations
        data = read_attribute name
        raise ArgumentError.new "translations should be a hash" unless translations.is_a?(Hash)
        data.update Hash[translations.map { |k,v| [k.to_s, v] }]
        write_attribute name, data
        data
      end

      def translated name, locale
        data = read_attribute name
        if data.is_a? Hash
          data[locale.to_s] || data[Translator.fallback_locale]
        else
          data
        end
      end
    end

    module ClassMethods
      def translates *args
        self.translated_attributes = args
        self.translated_attributes.each do |name|
          translated_attr_accessor name
          translations_attr_accessor name
        end
      end

      def translates? name
        self.translated_attributes.include? name
      end

      def translated_attributes
        @translated_attributes ||= []
      end

      def prefixed_attributes
        @prefixed_attributes ||= translated_attributes.map{ |a| Translator.prefixed(a) }.flatten
      end

      protected

      def translated_attributes= value
        @translated_attributes = value
      end

      def translated_attr_accessor name
        serialize name, ActiveRecord::Coders::Hstore

        attr_accessible *prefixed_attributes

        define_method("#{name}")  { |locale=nil| translated name, locale || I18n.locale }
        define_method("#{name}=") { |value|      translate  name, I18n.locale => value }

        Translator.prefixed_locales.each do |locale|
          define_method("#{locale}_#{name}")  { translated name, locale }
          define_method("#{locale}_#{name}=") { |value| translate name, locale => value }
        end
      end

      def translations_attr_accessor name
        define_method("#{name}_translations")  { read_attribute name }
        define_method("#{name}_translations=") { |value| write_attribute name, value }
      end
    end
  end
end

ActiveRecord::Base.send :include, Translator::Translates
