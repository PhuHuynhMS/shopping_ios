import Foundation
import Combine

class CartViewModel: ObservableObject {
    @Published var cartItems: [CartItem] = []
    @Published var orderId: String?
    @Published var errorMessage: String?
    @Published var isLoading = false

    private var cancellables = Set<AnyCancellable>()

    func submitOrder(token: String) {
        guard let url = URL(string: "http://localhost:3000/api/orders") else { return }

        let payload = [
            "cartData": cartItems.map { ["productId": $0.productId, "quantity": $0.quantity] }
        ]

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: payload)
        } catch {
            self.errorMessage = "Lỗi khi tạo dữ liệu gửi"
            return
        }

        isLoading = true

        URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { data, response -> [String: Any] in
                guard let httpResp = response as? HTTPURLResponse,
                      200..<300 ~= httpResp.statusCode else {
                    throw URLError(.badServerResponse)
                }
                let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
                return json ?? [:]
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                self.isLoading = false
                if case .failure(let error) = completion {
                    self.errorMessage = error.localizedDescription
                }
            }, receiveValue: { response in
                self.orderId = response["orderId"] as? String
                if let failed = response["failed"] as? [[String: Any]] {
                    let failedIds = failed.compactMap { $0["productId"] as? String }
                    self.cartItems = self.cartItems.map { item in
                        var newItem = item
                        newItem.isOverStock = failedIds.contains(item.productId)
                        return newItem
                    }
                }
            })
            .store(in: &cancellables)
    }

    func increaseQuantity(for item: CartItem) {
        if let index = cartItems.firstIndex(of: item) {
            cartItems[index].quantity += 1
        }
    }

    func decreaseQuantity(for item: CartItem) {
        if let index = cartItems.firstIndex(of: item), cartItems[index].quantity > 1 {
            cartItems[index].quantity -= 1
        }
    }

    func removeItem(at offsets: IndexSet) {
        cartItems.remove(atOffsets: offsets)
    }
}
