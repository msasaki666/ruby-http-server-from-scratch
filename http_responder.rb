class HttpResponder
  class << self
    STATUS_MESSAGES = {
      # ...
      200 => 'OK',
      # ...
      404 => 'Not Found',
      # ...
    }.freeze

    # status: int
    # headers: ハッシュ
    # body: 文字列の配列
    def call(conn, status, headers, body)
      # ステータス行
      status_text = STATUS_MESSAGES[status]
      conn.send("HTTP/1.1 #{status} #{status_text}\r\n", 0)

      # ヘッダー
      # 送信前に本文の長さを知る必要がある
      # それによってリモートクライアントが読み取りをいつ終えるかがわかる
      content_length = body.sum(&:length)
      conn.send("Content-Length: #{content_length}\r\n", 0)
      headers.each_pair do |name, value|
        conn.send("#{name}: #{value}\r\n", 0)
      end

      # コネクションを開きっぱなしにしたくないことを伝える
      conn.send("Connection: close\r\n", 0)

      # ヘッダーと本文の間を空行で区切る
      conn.send("\r\n", 0)

      # 本文
      body.each do |chunk|
        conn.send(chunk, 0)
      end
    end
  end
end
