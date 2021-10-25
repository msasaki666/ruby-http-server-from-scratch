require_relative 'http_responder'
require_relative 'request_parser'
require_relative 'socket_listener'
require_relative 'sample_app'

class SingleThreadedServer
  attr_reader :app

  # app: Rackアプリ
  def initialize(app)
    @app = app
  end

  def start
    tcp_server = SocketListener.call
    loop do # 新しいコネクションを継続的にリッスンする
      conn, _addr_info = tcp_server.accept
      request = RequestParser.call(conn)
      status, headers, body = app.call(request)
      HttpResponder.call(conn, status, headers, body)
    rescue => e
      puts e.message
    ensure # コネクションを常にクローズする
      conn&.close
    end
  end
end

SingleThreadedServer.new(SampleApp).start
