# -*- coding: utf-8 -*-
module StaffsHelper
  # JavaScript用エスケープ処理
  # ※JavaScript用エスケープ処理(ActionView::Helpers::JavaScriptHelper.escape_javascript)に、
  # 　シングルクォートのエスケープ処理を追加したもの
  # ==== Args
  # ==== Return
  # ==== Raise
  def escape_javascript_with_singlequote(message)
    escape_javascript(message).gsub(/'/, "''")
  end
  alias :jsq :escape_javascript_with_singlequote
end
