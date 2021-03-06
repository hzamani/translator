# encoding: utf-8

require 'spec_helper'

describe "ActiveRecord::Base" do
  describe "#translates" do
    before :each do
      I18n.locale = :en
    end

    it "changes translated attribute accessors to locale version" do
      post = Post.new title: 'New Post', content: 'This is a test post'
      I18n.locale = :fa
      post.title = 'اولین پست'
      post.title.should == 'اولین پست'
      I18n.locale = :en
      post.title.should == 'New Post'
      post.save
      post.reload
      post.title.should == 'New Post'
      I18n.locale = :fa
      post.title.should == 'اولین پست'
    end

    it "adds locale prefix attribute accessors for translated attributes" do
      post = Post.new
      post.should respond_to(:en_title)
      post.should respond_to(:fa_title)
      post.should respond_to(:en_title=)
      post.should respond_to(:fa_title=)
      post.fa_title = 'اولین پست'
      post.title_changed?.should == true
      post.en_title = 'New Post'
      post.save
      post.reload
      post.fa_title.should == 'اولین پست'
      post.en_title.should == 'New Post'
      post.title.should == 'New Post'
      I18n.locale = :fa
      post.title.should == 'اولین پست'
    end
  end

  describe "#prefixed_attributes" do
    context "Translator prefixes set" do
      it "returns a list of prefixed attributes" do
        Post.prefixed_attributes.should == [:en_title, :fa_title, :en_content, :fa_content]
      end
    end

    context "Translator prefixes not set" do
      it "returns list of attributes"
    end
  end

  describe "#translated_attributes" do
    it "return list of translated attribute names" do
      Post.translated_attributes.should == [:title, :content]
    end
  end
end
