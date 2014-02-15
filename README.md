# ValidatesFullwidthLengthOf

全角 n 文字のバリデーションをする Rails 用の gem です。

Rails 3, 4 に対応しています。

全角文字を 1 文字、半角文字を 0.5 文字としてカウントします。

## 使い方

まず、以下を Gemfile に追加して `bundle install` を実行します。

```ruby
gem 'validates_fullwidth_length_of', github: 'milk1000cc/validates_fullwidth_length_of'
```

次に、`validates_fullwidth_length_of` をモデルに追加してください。

```ruby
class User < ActiveRecord::Base
  validates_fullwidth_length_of :name, maximum: 5
end

User.new(name: 'aiueo12345').valid?  #=> true
User.new(name: 'あいうえお').valid?  #=> true
User.new(name: 'あいうえおa').valid?  #=> false
```

オプションは、`validates_length_of` と同じものが使えます。

エイリアスとして `validates_fullwidth_size_of` があります。

## エラーメッセージ

[i18n](http://guides.rubyonrails.org/i18n.html) に対応しています。

日本語の場合は `config/locales/ja.yml` などに以下を追加してください。

```yaml
ja:
  errors:
    messages:
      fullwidth_too_long: は全角%{count}文字以内で入力してください。
      fullwidth_too_short: は全角%{count}文字以上で入力してください。
      fullwidth_wrong_length: は全角%{count}文字で入力してください。
```

## Sexy Validation

Sexy Validation に対応しています。

```ruby
class User < ActiveRecord::Base
  validates :name, fullwidth_length: { maximum: 5 }
end
```

## 全角・半角の区別

全角・半角の区別は、Unicode 東アジアの文字幅 (http://www.unicode.org/reports/tr41/) に基づきます。

UTF-8 以外での動作は、考慮していません。

## 参考

[RubyとPythonで全角文字を半角文字2文字として数える その2](http://d.hatena.ne.jp/hush_puppy/20090227/1235740342)
