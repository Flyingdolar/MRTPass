module AuthorizedHelper
    def expect_unauthorized(response)
        expect(response).to have_http_status(401)
        expect(JSON.parse(response.body)).to eq(
          JSON.parse(
            {
              "error": true,
              "message": "Unauthorized",
              "status": "error",
              "data": "The user is not login."
            }.to_json
          )
        )      
    end

    def expect_not_permitted(response)
        expect(response).to have_http_status(403)
        expect(JSON.parse(response.body)).to eq(
          JSON.parse(
            {
              "status": "error",
              "error": true,
              "message": "Unauthorized",
              "data": "User not permitted for this action."
            }.to_json
          )
        )      
    end
end
