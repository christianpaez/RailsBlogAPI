require 'rails_helper'
require 'byebug'

RSpec.describe "Posts endpoint", type: :request do
    describe "GET /posts" do
        before { get '/posts'}
            it "Should return 200 Status code" do
                payload = JSON.parse(response.body)
                expect(payload).to be_empty
                expect(response).to have_http_status(200)
            end

            describe "with data in the database" do
                let!(:posts) { create_list(:post, 10, published: true)}
                it " should return all the posts" do
                    get '/posts'
                    payload = JSON.parse(response.body)
                    expect(payload.size).to eq(posts.size)
                    expect(response).to have_http_status(200)

                end
                describe "GET /posts/:id" do
                    let!(:post) { create(:post)}
                    before { get "/posts/#{post.id}" }
                    it "Should return a single post" do
                        payload = JSON.parse(response.body)
                        expect(payload).not_to be_empty
                        expect(payload['id']).to eq(post.id)
                        expect(response).to have_http_status(200)
                    end
                end
            end
    end 

    describe "POST /posts" do
        let!(:user) {create(:user)}
            it "Should create a post" do
                req_payload = {
                    post: {
                    title: "titulo", 
                    content: "contenido",
                    published: false,
                    user_id: user.id
                    }
                }
                post "/posts", params: req_payload
                payload = JSON.parse(response.body)
                expect(payload).to_not be_empty
                expect(payload["id"]).to_not be_nil
                expect(response).to have_http_status(:created)
            end

            it "Should return an error message on invalid post" do
                #NO TITLE PAYLOAD
                req_payload = {
                    post: {
                    content: "contenido",
                    published: false,
                    user_id: user.id
                    }
                }
                post "/posts", params: req_payload
                payload = JSON.parse(response.body)
                expect(payload).to_not be_empty
                expect(payload["error"]).to_not be_empty
                expect(response).to have_http_status(:unprocessable_entity)
            end
    end 
    describe "PUT /posts" do
        let!(:article) {create(:post)}
            it "Should update a post" do
                req_payload = {
                    post: {
                    title: "titulo", 
                    content: "contenido",
                    published: false,
                    }
                }
                put "/posts/#{article.id}", params: req_payload
                payload = JSON.parse(response.body)
                expect(payload).to_not be_empty
                expect(payload["id"]).to eq(article.id)
                expect(response).to have_http_status(:ok)
            end
            it "Should return an error message on invalid post" do
                #NIL PAYLOAD
                req_payload = {
                    post: {
                    title: nil,
                    content: nil,
                    published: false,
                    }
                }
                 put "/posts/#{article.id}", params: req_payload
                 payload = JSON.parse(response.body)
                 expect(payload).to_not be_empty
                 expect(payload["error"]).to_not be_empty
                 expect(response).to have_http_status(:unprocessable_entity)
            end
    end 
end






