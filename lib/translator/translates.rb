module Translator
  def self.fallback_locale= locale
    @@fallback_locale = locale.to_s
  end

  def self.fallback_locale
    @@fallback_locale ||= nil
  end

  def self.prefixed_locales= locales
    @@prefixed_locales = locales
  end

  def self.prefixed_locales
    @@prefixed_locales ||= []
  end

  module Translates
    extend ActiveSupport::Concern

    included do
      def translate name, arg
        if arg.is_a?(Hash)
          add_translation name, arg
        else
          read_translation name, arg
        end
      end

      def add_translation name, translations
        data = read_attribute name
        data = {'en' => data} unless data.is_a? Hash
        raise "translations should be a hash with locales as keys" unless translations.is_a?(Hash)
        data.update Hash[translations.map { |k,v| [k.to_s, v] }]
        write_attribute name, data
        data
      end

      def read_translation name, locale
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
        translator_fields.include? name
      end

      def translated_attributes
        @@translated_attributes ||= []
      end

      protected

      def translated_attributes= value
        @@translated_attributes = value
      end

      def translated_attr_accessor name
        serialize name, ActiveRecord::Coders::Hstore
        define_method "#{name}" do |locale=nil|
          read_translation name, locale || I18n.locale
        end
        define_method "#{name}=" do |value|
          add_translation name, I18n.locale => value
        end
        Translator.prefixed_locales.each do |locale|
          define_method "#{locale}_#{name}" do
            read_translation name, locale
          end
          define_method "#{locale}_#{name}=" do |value|
            add_translation name, locale => value
          end
        end
      end

      def translations_attr_accessor name
        define_method "#{name}_translations" do
          read_attribute name
        end
        define_method "#{name}_translations=" do |value|
          write_attribute name, value
        end
      end
    end
  end
end

ActiveRecord::Base.send :include, Translator::Translates
