# -*- coding: utf-8 -*-
require File.join(File.dirname(__FILE__), './spec_helper')

class Topic < ActiveRecord::Base
  define_table do |t|
    t.string :title
  end
end

describe ActiveRecord::Validations::ClassMethods do
  describe '::validates_fullwidth_length_of' do
    it 'は、allow_nil オプションが true のとき、値が nil でも正当だと判断すること' do
      Topic.validates_fullwidth_length_of(:title, :is => 5, :allow_nil => true)

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
  end
end
