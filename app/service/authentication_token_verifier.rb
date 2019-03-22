require 'httparty'

class AuthenticationTokenVerifier
    include HTTParty

    AUTHENTICATION_ENDPOINT = 'https://jobhub-authentication-staging.herokuapp.com'
    base_uri AUTHENTICATION_ENDPOINT
    
    class<<self
        def verify_request(token)
            get(
                '/users/self',
                headers: default_headers(token)
            )
        end

        private

        def default_headers(token)
            {
                "Content-type": "application/json",
                "Authorization": "Bearer #{token}"
            }
        end
    end
    
end
