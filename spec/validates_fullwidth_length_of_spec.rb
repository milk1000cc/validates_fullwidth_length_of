# -*- coding: utf-8 -*-
require File.join(File.dirname(__FILE__), './spec_helper')

class Topic < ActiveRecord::Base
  define_table do |t|
    t.string :title
    t.text :content
  end
end

describe ActiveRecord::Validations::ClassMethods do
  after do
    [:validate, :validate_on_create, :validate_on_update].each do |cb|
      Topic.instance_variable_set("@#{ cb.to_s }_callbacks", nil)
    end
  end

  describe '::validates_fullwidth_length_of' do
    it 'は、nil を許容する allow_nil オプションを指定できること' do
      Topic.class_eval do
        validates_fullwidth_length_of(:title, :is => 5, :allow_nil => true)
      end

      Topic.create('title' => 'ab').should_not be_valid
      Topic.create('title' => '').should_not be_valid
      Topic.create('title' => 'abcde').should_not be_valid
      Topic.create('title' => 'ｱｲｳｴｵ').should_not be_valid
      Topic.create('title' => 'ｱｲｳｴｵｱｲｳｴ').should_not be_valid
      Topic.create('title' => 'ｱｲｳｴｵｱｲｳｴｵa').should_not be_valid
      Topic.create('title' => nil).should be_valid
      Topic.create('title' => 'abcdeabcde').should be_valid
      Topic.create('title' => 'アイウエオ').should be_valid
      Topic.create('title' => 'ｱｲｳｴｵｱｲｳｴｵ').should be_valid
      Topic.create('title' => 'あいうｴｵｴｵ').should be_valid
    end

    it 'は、空文字列を許容する allow_blank オプションを指定できること' do
      Topic.validates_fullwidth_length_of(:title, :is => 5, :allow_blank => true)

      Topic.create('title' => 'ab').should_not be_valid
      Topic.create('title' => '').should be_valid
      Topic.create('title' => 'abcde').should_not be_valid
      Topic.create('title' => 'ｱｲｳｴｵ').should_not be_valid
      Topic.create('title' => 'ｱｲｳｴｵｱｲｳｴ').should_not be_valid
      Topic.create('title' => 'ｱｲｳｴｵｱｲｳｴｵa').should_not be_valid
      Topic.create('title' => nil).should be_valid
      Topic.create('title' => 'abcdeabcde').should be_valid
      Topic.create('title' => 'アイウエオ').should be_valid
      Topic.create('title' => 'ｱｲｳｴｵｱｲｳｴｵ').should be_valid
      Topic.create('title' => 'あいうｴｵｴｵ').should be_valid
    end

    it 'は、最小全角文字数を minimum オプションで指定できること' do
      Topic.validates_fullwidth_length_of :title, :minimum => 5

      t = Topic.create("title" => "ｖａｌｉｄ", "content" => "whatever")
      t.should be_valid

      t.title = "abcde"
      t.should_not be_valid
      t.errors.on :title
      t.errors[:title].should == 'is too short (minimum is 5 characters)'

      t.title = ""
      t.should_not be_valid
      t.errors.on :title
      t.errors[:title].should == 'is too short (minimum is 5 characters)'

      t.title = nil
      t.should_not be_valid
      t.errors.on :title
      t.errors[:title].should == 'is too short (minimum is 5 characters)'
    end
  end
end
