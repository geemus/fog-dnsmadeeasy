module Fog
  module DNS
    class DNSMadeEasy
      class Real
        # Gets record from given domain.
        #
        # ==== Parameters
        # * domain<~String> - domain numeric ID
        # * record_id<~String>
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'record'<~Hash> The representation of the record.
        def get_record(domain, record_id)
          request(
            :expects  => 200,
            :method   => "GET",
            :path     => "/V2.0/dns/managed/#{domain}/records/#{record_id}"
          )
        end
      end

      class Mock
        def get_record(domain, record_id)
          response = Excon::Response.new

          if self.data.key?(domain)
            response.status = 200
            response.body = self.data[domain].find { |record| record["id"] == record_id }

            if response.body.nil?
              response.status = 404
              response.body = {
                "error" => "Couldn't find Record with id = #{record_id}"
              }
            end
          else
            response.status = 404
            response.body = {
              "error" => "Couldn't find Domain with name = #{domain}"
            }
          end
          response
        end
      end
    end
  end
end