require 'protobuf'
require 'protobuf/rpc/version'

module Protobuf
  # See Protobuf#connector_type documentation.
  CONNECTORS = [:socket, :zmq].freeze

  # Default is Socket as it has no external dependencies.
  DEFAULT_CONNECTOR = :socket

  module_function

  class << self
    # Client Host
    #
    # Default: `hostname` of the system
    #
    # The name or address of the host to use during client RPC calls.
    attr_accessor :client_host
  end

  self.client_host = Socket.gethostname

  # Connector Type
  #
  # Default: socket
  #
  # Symbol value which denotes the type of connector to use
  # during client requests to an RPC server.
  def self.connector_type
    @connector_type ||= DEFAULT_CONNECTOR
  end

  def self.connector_type=(type)
    fail ArgumentError, 'Invalid connector type given' unless CONNECTORS.include?(type)
    @connector_type = type
  end

  # GC Pause during server requests
  #
  # Default: false
  #
  # Boolean value to tell the server to disable
  # the Garbage Collector when handling an rpc request.
  # Once the request is completed, the GC is enabled again.
  # This optomization provides a huge boost in speed to rpc requests.
  def self.gc_pause_server_request?
    return @gc_pause_server_request unless @gc_pause_server_request.nil?
    self.gc_pause_server_request = false
  end

  def self.gc_pause_server_request=(value)
    @gc_pause_server_request = !!value
  end
end

module Protobuf
  module Rpc
    # Your code goes here...
  end
end

# Leaving this in place because you might want to debug protobuf without networking
unless ENV.key?('PB_NO_NETWORKING')
  require 'protobuf/rpc/client'
  require 'protobuf/rpc/service'

  env_connector_type = ENV.fetch('PB_CLIENT_TYPE') do
    ::Protobuf::DEFAULT_CONNECTOR
  end.to_s.downcase.strip.to_sym

  if ::Protobuf::CONNECTORS.include?(env_connector_type)
    require "protobuf/#{env_connector_type}"
  else
    $stderr.puts <<-WARN
    [WARNING] Require attempted on an invalid connector type '#{env_connector_type}'.
              Falling back to default '#{::Protobuf::DEFAULT_CONNECTOR}' connector.
    WARN

    require "protobuf/#{::Protobuf::DEFAULT_CONNECTOR}"
  end
end
