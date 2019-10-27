require 'rails_helper'
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
end
