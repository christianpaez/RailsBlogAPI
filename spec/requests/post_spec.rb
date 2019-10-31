require 'rails_helper'
require 'byebug'

RSpec.describe "Posts endpoint", type: :request do
    describe "GET /posts" do
            it "Should return 200 Status code" do
                get '/posts'
                payload = JSON.parse(response.body)
                expect(payload).to be_empty
                expect(response).to have_http_status(200)
            end

            
            describe "Search Posts" do
                let!(:first_post) { create(:post, title:"Post first", published: true) }
                let!(:second_post) { create(:post, title:"Post second", published: true) }
                let!(:third) { create(:post, title:"third", published: true) }
                it "should filter posts by title" do 
                    get '/posts?search=Post'
                    payload = JSON.parse(response.body)
                    expect(payload).to_not be_empty
                    expect(payload.size).to eq(2)
                    expect(payload.map {|p| p["id"]}.sort).to eq([first_post.id, second_post.id].sort)
                    expect(response).to have_http_status(200)
                end
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
                    #let!(:post) { create(:post)}
                    post = {
                        title: "titulo",
                        id: 1,
                        content: "contenido",
                        published: true,
                        author: {
                            id: 1, 
                            email: "email",
                            name: "name"
                        }
                    }
                    before { get "/posts/#{post[:id]}" }
                    it "Should return a single post" do
                        payload = JSON.parse(response.body)
                        expect(payload).not_to be_empty
                        expect(payload['id']).to eq(post[:id])
                        expect(payload['title']).to eq(post.title)
                        expect(payload['content']).to eq(post.content)
                        expect(payload['published']).to eq(post.published)
                        expect(payload['author']["name"]).to eq(post.author.name)
                        expect(payload['author']["email"]).to eq(post.author.email)
                        expect(payload['author']["id"]).to eq(post.author.id)
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






