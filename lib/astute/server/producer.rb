#    Copyright 2013 Mirantis, Inc.
#
#    Licensed under the Apache License, Version 2.0 (the "License"); you may
#    not use this file except in compliance with the License. You may obtain
#    a copy of the License at
#
#         http://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
#    WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
#    License for the specific language governing permissions and limitations
#    under the License.

module Astute
  module Server

    class Producer
      def initialize(exchange)
        @exchange = exchange
      end

      def publish(message, options={})
        default_options = {:routing_key => Astute.config.broker_publisher_queue,
                           :content_type => 'application/json'}
        options = default_options.merge(options)

        EM.next_tick {
          begin
            @exchange.publish(message.to_json, options)
          rescue
            Astute.logger.error "Error publishing message: #{$!}"
          end
        }
      end
    end

  end #Server
end #Astute
