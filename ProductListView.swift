import SwiftUI

struct PostListView: View {
    @StateObject private var viewModel = PostViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(viewModel.posts) { post in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(post.title.capitalized)
                                .font(.headline)
                            Text(post.body)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        .padding()
                        .background(Color(.systemBackground))
                        .cornerRadius(10)
                        .shadow(radius: 1)
                        .onAppear {
                            Task {
                                await viewModel.fetchMoreIfNeeded(current: post)
                            }
                        }
                    }

                    if viewModel.isLoading {
                        ProgressView().padding()
                    }
                }
                .padding()
            }
            .navigationTitle("Danh sách bài viết")
            .refreshable {
                await viewModel.fetchInitialPosts()
            }
            .task {
                await viewModel.fetchInitialPosts()
            }
        }
    }
}
