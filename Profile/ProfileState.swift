import Foundation

@MainActor
class ProfileViewModel: ObservableObject {
    @Published var orders: [Order] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    func fetchOrders(for userId: String, token: String) {
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                let fetchedOrders = try await APIService.shared.fetchOrders(userId: userId, token: token)
                self.orders = fetchedOrders
            } catch APIError.unauthorized {
                errorMessage = "Bạn chưa đăng nhập hoặc token đã hết hạn."
            } catch {
                errorMessage = "Lỗi khi tải đơn hàng. Vui lòng thử lại."
            }
            isLoading = false
        }
    }
}
