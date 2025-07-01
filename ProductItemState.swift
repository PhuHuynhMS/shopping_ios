import Foundation

@MainActor
class PostViewModel: ObservableObject {
    @Published var posts: [Post] = []
    @Published var isLoading = false
    
    private var page = 1
    private let limit = 10
    private var canLoadMore = true

    func fetchInitialPosts() async {
        page = 1
        canLoadMore = true
        posts = []
        await fetchPosts()
    }
    
    func fetchMoreIfNeeded(current post: Post) async {
        guard let last = posts.last, post == last else { return }
        await fetchPosts()
    }

    private func fetchPosts() async {
        guard !isLoading && canLoadMore else { return }
        isLoading = true

        let urlString = "https://jsonplaceholder.typicode.com/posts?_page=\(page)&_limit=\(limit)"
        guard let url = URL(string: urlString) else {
            isLoading = false
            return
        }

        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw URLError(.badServerResponse)
            }

            let newPosts = try JSONDecoder().decode([Post].self, from: data)

            posts += newPosts
            page += 1
            canLoadMore = !newPosts.isEmpty
        } catch {
            print("❌ Error fetching posts: \(error)")
        }

        isLoading = false
    }
}
