# -*- coding: utf-8 -*-
require File.join(File.dirname(__FILE__), './spec_helper')

class Topic < ActiveRecord::Base
  define_table do |t|
    t.string :title
    t.text :content
  end
end

describe ActiveRecord::Validations::ClassMethods do
  describe 'validates_fullwidth_length_of' do
    before do
      [:validate].each do |cb|
        Topic.reset_callbacks(cb)
      end
    end

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
      Topic.create('title' => 'aiueoアイウエオ').should_not be_valid
      Topic.create('title' => 'ｱｲｳｴｵｱｲｳｴｵ').should be_valid
      Topic.create('title' => 'ｱｲｳｴｵｱｲｳｴｵaiueo').should_not be_valid
      Topic.create('title' => 'あいうｴｵｴｵ').should be_valid
      Topic.create('title' => 'あいうｴｵｴｵaiueo').should_not be_valid
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

      Topic.create('title' => 'abcdeabcdea').should_not be_valid
      Topic.create('title' => 'アイウエオaiueo').should_not be_valid
      Topic.create('title' => 'ｱｲｳｴｵｱｲｳｴｵaiueo').should_not be_valid
      Topic.create('title' => 'あいうｴｵｴｵaiueo').should_not be_valid
    end

    it 'は、最小全角文字数を minimum オプションで指定できること' do
      Topic.validates_fullwidth_length_of :title, :minimum => 5

      t = Topic.create("title" => "ｖａｌｉｄ", "content" => "whatever")
      t.should be_valid

      t = Topic.create("title" => "ｖａｌｉok", "content" => "whatever")
      t.should be_valid

      t.title = "abcde"
      t.should_not be_valid
      t.errors[:title].should == ['is too short (minimum is 5 characters)']

      t.title = ""
      t.should_not be_valid
      t.errors[:title].should == ['is too short (minimum is 5 characters)']

      t.title = nil
      t.should_not be_valid
      t.errors[:title].should == ['is too short (minimum is 5 characters)']
    end

    it 'は、allow_nil などのオプションを :minimum 使用時も指定できること' do
      Topic.validates_fullwidth_length_of :title, :minimum => 5, :allow_nil => true

      t = Topic.create("title" => "ｖａｌｉｄ", "content" => "whatever")
      t.should be_valid

      t = Topic.create("title" => "ｖａｌｉok", "content" => "whatever")
      t.should be_valid

      t.title = nil
      t.should be_valid
    end

    it 'は、最大全角文字数を maximum オプションで指定できること' do
      Topic.validates_fullwidth_length_of :title, :maximum => 5

      t = Topic.create("title" => "ｖａｌｉｄ", "content" => "whatever")
      t.should be_valid

      t = Topic.create("title" => "ｖａｌｉｄinvalid", "content" => "whatever")
      t.should_not be_valid

      t.title = "ａｂｃｄｅf"
      t.should_not be_valid
      t.errors[:title].should == ['is too long (maximum is 5 characters)']

      t.title = ""
      t.should be_valid
    end

    it 'は、allow_nil などのオプションを :maximum 使用時も指定できること' do
      Topic.validates_fullwidth_length_of :title, :maximum => 5, :allow_nil => true

      t = Topic.create("title" => "ｖａｌｉｄ", "content" => "whatever")
      t.should be_valid

      t = Topic.create("title" => "inｖａｌｉｄ", "content" => "whatever")
      t.should_not be_valid

      t = Topic.create("title" => "invalidinvalid", "content" => "whatever")
      t.should_not be_valid

      t.title = nil
      t.should be_valid
    end

    it 'は、全角文字数の範囲を within オプションで指定できること' do
      Topic.validates_fullwidth_length_of :title, :content, :within => 3..5

      t = Topic.create("title" => "short", "content" => "私は、長い。")
      t.should_not be_valid
      t.errors[:title].should == ["is too short (minimum is 3 characters)"]
      t.errors[:content].should == ["is too long (maximum is 5 characters)"]

      t = Topic.create("title" => "short", "content" => "私は、長ii。")
      t.should_not be_valid
      t.errors[:title].should == ["is too short (minimum is 3 characters)"]
      t.errors[:content].should == ["is too long (maximum is 5 characters)"]

      t.title = nil
      t.content = nil
      t.should_not be_valid
      t.errors[:title].should == ["is too short (minimum is 3 characters)"]
      t.errors[:content].should == ["is too short (minimum is 3 characters)"]

      t.title = "あいう"
      t.content = 'abcdef'
      t.should be_valid

      t.title = "あいuu"
      t.should be_valid
    end

    it 'は、allow_nil などのオプションを :within 使用時も指定できること' do
      Topic.validates_fullwidth_length_of :title, :content, :within => 3..5, :allow_nil => true

      t = Topic.create("title" => "ｖａｌｉｄ", "content" => "whatever")
      t.should be_valid

      t = Topic.create("title" => "ｖａｌｉok", "content" => "whatever")
      t.should be_valid

      t = Topic.create("title" => "inｖａｌｉｄ", "content" => "whatever")
      t.should_not be_valid

      t.title = nil
      t.should be_valid
    end

    it 'は、作成時だけ検証する設定が出来ること' do
      Topic.validates_fullwidth_length_of :title, :content, :within => 5..10, :on => :create, :too_long => '永杉: %{count}'

      t = Topic.new('title' => '長い長い長い長い長いa', 'content' => 'ｖａｌｉｄ')
      t.save.should be_false
      t.errors[:title].should == ["永杉: 10"]

      t.title = '作成できますよ'
      t.save.should be_true

      t.title = '短い'
      t.save.should be_true

      t.content = "そして、これは長いんですが、大丈夫なんですよね。"
      t.save.should be_true

      t.content = t.title = 'ok'
      t.save.should be_true
    end

    it 'は、更新時だけ検証する設定が出来ること' do
      Topic.validates_fullwidth_length_of :title, :content, :within => 5..10, :on => :update, :too_short => '短すぎ: %{count}'

      t = Topic.new('title' => '短い', 'content' => 'ｖａｌｉｄ')
      t.save.should be_true

      t.save.should be_false
      t.errors[:title].should_not be_nil

      t.title = 'bad'
      t.save.should be_false
      t.errors[:title].should == ['短すぎ: 5']

      t.title = '大丈夫です'
      t.content = 'しかし、こちらが大丈夫ではなくなりました。'
      t.save.should be_false
      t.errors[:content].should_not be_nil

      t.content = t.title = '大丈夫です'
      t.save.should be_true
    end

    it 'は、全角文字数制限を is オプションで指定できること' do
      Topic.validates_fullwidth_length_of :title, :is => 5

      t = Topic.create("title" => "ｖａｌｉｄ", "content" => "ｗｈａｔｅｖｅｒ")
      t.should be_valid

      t = Topic.create("title" => "ｖａｌｉok", "content" => "ｗｈａｔｅｖｅｒ")
      t.should be_valid

      t.title = "not!!"
      t.should_not be_valid
      t.errors[:title].should_not be_nil
      t.errors[:title].should == ["is the wrong length (should be 5 characters)"]

      t.title = ""
      t.should_not be_valid

      t.title = nil
      t.should_not be_valid
    end

    it 'は、allow_nil などのオプションを :is 使用時も指定できること' do
      Topic.validates_fullwidth_length_of :title, :is => 5, :allow_nil => true

      t = Topic.create("title" => "ｖａｌｉｄ", "content" => "ｗｈａｔｅｖｅｒ")
      t.should be_valid

      t.title = nil
      t.should be_valid
    end

    it 'は、大きな範囲で文字数制限されても問題ないこと' do
      bigmin = 2 ** 30
      bigmax = 2 ** 32
      bigrange = bigmin...bigmax
      proc {
        Topic.validates_fullwidth_length_of :title, :is => bigmin + 5
        Topic.validates_fullwidth_length_of :title, :within => bigrange
        Topic.validates_fullwidth_length_of :title, :in => bigrange
        Topic.validates_fullwidth_length_of :title, :minimum => bigmin
        Topic.validates_fullwidth_length_of :title, :maximum => bigmax
      }.should_not raise_error
    end
  end
end
