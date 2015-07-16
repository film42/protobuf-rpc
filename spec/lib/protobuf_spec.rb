require 'spec_helper'
require 'protobuf'

RSpec.describe ::Protobuf do

  describe '.client_host' do
    after { ::Protobuf.client_host = nil }

    subject { ::Protobuf.client_host }

    context 'when client_host is not pre-configured' do
      it { is_expected.to eq `hostname`.chomp }
    end

    context 'when client_host is pre-configured' do
      let(:hostname) { 'override.myhost.com' }
      before { ::Protobuf.client_host = hostname }
      it { is_expected.to eq hostname }
    end
  end

  describe '.connector_type' do
    before { described_class.instance_variable_set(:@connector_type, nil) }

    it 'defaults to socket' do
      expect(described_class.connector_type).to eq :socket
    end

    it 'accepts socket or zmq' do
      [:socket, :zmq].each do |type|
        described_class.connector_type = type
        expect(described_class.connector_type).to eq type
      end
    end

    it 'does not accept other types' do
      [:hello, :world, :evented].each do |type|
        expect do
          described_class.connector_type = type
        end.to raise_error(ArgumentError)
      end
    end
  end

  describe '.gc_pause_server_request?' do
    before { described_class.instance_variable_set(:@gc_pause_server_request, nil) }

    it 'defaults to a false value' do
      expect(described_class.gc_pause_server_request?).to be false
    end

    it 'is settable' do
      described_class.gc_pause_server_request = true
      expect(described_class.gc_pause_server_request?).to be true
    end
  end

end
