require 'httparty'
require 'json'
require 'date'
require 'uri'

class Briq
    include HTTParty

    def initialize(access_token=nil, org_name=nil)
        # @access_token = access_token
        @base_uri     = "https://www.givebriq.com/v0/organizations/"
        @org_name     = URI.escape(org_name)
        @auth = {:username => access_token, :password => ""}
        @headers = {"Content-Type": "application/json"}
    end
    
    def get_organization
        make_request '', 'get'
    end
    
    def list_users(per_page = 100, page = 1)
        opts = {'per_page': per_page , 'page': page}
        make_request '/users', 'get', query = opts
    end
    
    def get_user(user_id)
        make_request "/users/#{user_id}", 'get'
    end
    
    def list_groups(per_page = 100, page = 1)
        opts = {'per_page': per_page , 'page': page}
        make_request '/groups', 'get', query = opts
    end
    
    def get_group(group_id)
        make_request "/groups/#{group_id}", 'get'
    end
    
    def list_transactions(per_page = 100, page = 1)
        opts = {'per_page': per_page , 'page': page}
        make_request '/transactions', 'get', query = opts
    end
    
    def get_transaction(transaction_id)
        make_request "/transactions/#{transaction_id}", 'get'
    end
    
    def create_transaction(from='', to='', amount = 1, comment = 'congrats', query = {})
        if from == '' && to == ''
            raise ArgumentError.new('Need at least a sender or a receiver')
        elsif comment == ''
            raise ArgumentError.new('Need a comment along with the briqs')
        end
        opts = {'from': from , 'to': to, 'amount': amount, 'comment': comment}
        p opts
        make_request '/transactions', 'post', query = query,  body = opts
    end
    
    def delete_transaction(transaction_id)
        make_request "/transactions/#{transaction_id}", 'delete'
    end
    
  private

    def make_request(method = '', verb = '', query = {}, body = {})
        r = self.class.send(
            verb,
            @base_uri + @org_name + method,
            query: query,
            body: body.to_json,
            headers: @headers,
            format: :plain,
            basic_auth: @auth
          )
        JSON.parse r, symbolize_names: true if verb != 'delete'
    end
end