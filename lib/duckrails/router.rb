module Duckrails
  class Router
    METHODS = [:get, :post, :put, :patch, :delete, :options, :head].freeze

    REGISTERED_MOCKS = []

    class << self
      def register_mock(mock)
        p "Registering #{mock.id}"
        REGISTERED_MOCKS << mock.id
        REGISTERED_MOCKS.uniq!
      end

      def register_current_mocks
        REGISTERED_MOCKS << Duckrails::Mock.pluck(:id)
        REGISTERED_MOCKS.flatten!
      end

      def unregister_mock(mock)
        REGISTERED_MOCKS.delete mock.id
      end

      def load_mock_routes!
        REGISTERED_MOCKS.each do |mock_id|
          p "Defining: #{mock_id}"
          define_route Duckrails::Mock.find mock_id
        end
      end

      protected

      def define_route(mock)
        Duckrails::Application.routes.draw do
          self.send(mock.method, mock.route_path, to: 'duckrails/mocks#mockify', defaults: { duckrails_mock_id: mock.id })
        end
      end
    end
  end
end
