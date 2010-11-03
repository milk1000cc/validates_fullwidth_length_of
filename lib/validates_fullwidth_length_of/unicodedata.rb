# -*- coding: utf-8 -*-
require "singleton"

# UnicodeDataクラス(Singleton)
#   メソッドはeast_asian_widthしかない
#   以下のURLにあるEastAsianWidth.txtが必要
#   http://www.unicode.org/Public/UNIDATA/EastAsianWidth.txt
class Unicodedata
  include Singleton

  # コンストラクタ
  def initialize()
    # 定義ファイル読み込み
    f = open(File.join(File.dirname(__FILE__), "EastAsianWidth.txt"), "r")
    lines = f.readlines
    f.close

    @list = Array.new
    for line in lines
      s_code, e_code, eaw = get_code(line)
      next unless s_code and e_code and eaw

      # 同じ定義が連続した時は範囲を連結
      if @list[-1] and s_code == (@list[-1][1] + 1) and eaw == @list[-1][2]
        @list[-1][1] = e_code       # 連結
      else
        @list << [s_code, e_code, eaw]      # 新規
      end
    end
  end

  # EastAsianWidth取得
  def Unicodedata.east_asian_width(character)
    uni = Unicodedata.instance
    return uni.east_asian_width(character)
  end

  # EastAsianWidth取得
  def east_asian_width(character)
    find_code = character.unpack("U")[0].to_i   # 検索するUnicode番号
    return bsearch(find_code, @list, 0, @list.size - 1)
  end

  # 2分探索(再帰)
  # 見つからなかったら"N"を返す
  def bsearch(target, list, min, max)
    return "N" if min > max     # 発見できず

    index = (min + max) / 2
    s_code, e_code, eaw = list[index]    # 定義取得

    # Unicode番号を比較して不一致なら再帰
    if s_code > target    # もっと前
      return bsearch(target, list, min, index-1)
    elsif e_code < target    # もっと後ろ
      return bsearch(target, list, index+1, max)
    end
    # Unicode番号 一致
    return eaw
  end
  private :bsearch

  # Unicode番号とEastAsianWidthを取得
  def get_code(line)
    line.chomp!
    line = line.gsub(/\s*#.*/, "")     # コメント削除
    return unless /.+;.+/ =~ line      # データ行ではない

    code_n_eaw = line.split(/\s*;\s*/)
    codes = code_n_eaw[0].split(/\s*\.\.\s*/)

    s_code = codes[0].hex     # Unicode番号
    e_code = codes[1] ? codes[1].hex : s_code       # 範囲指定なら終了番号
    eaw = code_n_eaw[1] ? code_n_eaw[1].strip : nil     # EastAsianWidth

    return s_code, e_code, eaw
  end
  private :get_code
end

# あらかじめ読み込んでおく
Unicodedata.instance
