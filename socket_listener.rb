require 'socket'
class SocketListener
  class << self
    PORT = ENV.fetch('PORT', 3000)
    HOST = ENV.fetch('HOST', '127.0.0.1').freeze
    # バッファに保存する受信コネクション数
    SOCKET_READ_BACKLOG = ENV.fetch('TCP_BACKLOG', 12).to_i

    # def call
    #   # TCP通信用のソケットを作成
    #   socket = Socket.new(:INET, :STREAM)
    #   socket.setsockopt(Socket::SOL_SOCKET, Socket::SO_REUSEADDR, true)
    #   socket.bind(Addrinfo.tcp(HOST, PORT))
    #   socket.listen(SOCKET_READ_BACKLOG)
    #   socket
    # end

    # 書き方は色々ある
    def call
      tcp_server = TCPServer.new(HOST, PORT)
      tcp_server.listen(SOCKET_READ_BACKLOG)
      tcp_server
    end
  end
end
