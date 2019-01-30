require 'httparty'
require 'json'
require 'date'
require 'uri'

class Briq
    include HTTParty

    def initialize(access_token=nil, org_name=nil)
        # @access_token = access_token
        @base_uri     = 'https://www.givebriq.com/v0/organizations/'
        @org_name     = URI.escape(org_name)
        @auth = {:username => access_token, :password => ""}
        @headers = {'Content-Type': 'application/json'}
    end
    
    def get_organization
        make_request '', 'get'
    end
    
    def list_users(per_page=100, page=1)
        opts = {'per_page': per_page , 'page': page}
        make_request '/users', verb='get', query=opts
    end
    
    def get_user(user_id)
        get_request "/users/#{user_id}"
    end
    
    def list_groups(per_page=100, page=1)
        opts = {'per_page': per_page , 'page': page}
        get_request '/groups', query=opts
    end
    
    def get_group(group_id)
        get_request "/groups/#{group_id}"
    end
    
    def list_transactions(per_page=100, page=1)
        opts = {'per_page': per_page , 'page': page}
        get_request '/transactions', query=opts
    end
    
    def get_transaction(transaction_id)
        get_request "/transactions/#{transaction_id}"
    end
    
    def create_transaction(from="", to="", amount=1, comment="")
        if from == "" && to ==""
            raise ArgumentError.new("You need to specify at least a sender or a receiver")
        elsif comment == ""
            raise ArgumentError.new("You need to send a comment along with the briqs")
        end
        opts = {'from': from , 'to': to, 'amount': amount, 'comment': comment}
        post_request '/transactions', query=opts.to_json
    end
    
    def delete_transaction(transaction_id)
        make_request "/transactions/#{transaction_id}", 'delete'
    end
    
    private
    
    def make_request(method="", verb='', query={}, body={})
        url = @base_uri + @org_name + method
        r = self.class.send(verb, url, query: query, headers: @headers, format: :plain, basic_auth: @auth)
        JSON.parse r, symbolize_names: true if verb != 'delete'
    end
    # 
    # def get_request(method="", query={})
    #     url = @base_uri + @org_name + method
    #     r = self.class.get(url, query: query, headers: @headers, format: :plain, basic_auth: @auth)
    #     JSON.parse r, symbolize_names: true
    # end
    # 
    # def post_request(method="", body={})
    #     url = @base_uri + @org_name + method
    #     r = self.class.post(url, body: body, headers: @headers, format: :plain, basic_auth: @auth)
    #     JSON.parse r, symbolize_names: true
    # end
    # def delete_request(method="", body={})
    #     url = @base_uri + @org_name + method
    #     r = self.class.delete(url, headers: @headers, format: :plain, basic_auth: @auth)
    # end
end