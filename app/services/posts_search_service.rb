class PostsSearchService
    def self.search(current_posts, query_params)
        current_posts.where("title like '%#{query_params}%'")
    end
end