# encoding: utf-8

require 'spec_helper'

describe 'Translator' do
  describe 'translates' do
    before :each do
      I18n.locale = :en
    end

    it "change translated attribute accessors to locale version" do
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
      pending
      post = Post.new
      post.should respond_to(:en_title)
      post.should respond_to(:fa_title)
      post.should respond_to(:en_title=)
      post.should respond_to(:de_title=)
      post.fa_title = 'اولین پست'
      post.en_title = 'New Post'
      post.save
      post.reload
      post.fa_title.should == 'اولین پست'
      post.en_title.should == 'New Post'
    end

    describe "#translated_attributes" do
      it "return list of translated attribute names" do
        Post.translated_attributes.should == [:title, :content]
      end
    end
  end
end
