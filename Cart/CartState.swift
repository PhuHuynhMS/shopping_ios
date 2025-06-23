import Foundation

class CartViewModel: ObservableObject {
    @Published var cartItems: [CartItem] = []

    private let storageKey = "cart_items"

    init() {
        loadFromAppStorage()
    }

    func addToCart(_ product: Product) {
        // Tìm xem đã có trong cart chưa
        if let index = cartItems.firstIndex(where: { $0.product.id == product.id }) {
            let currentItem = cartItems[index]
            // Kiểm tra stock
            if currentItem.quantity < product.stock {
                cartItems[index].quantity += 1
                saveToAppStorage()
            } else {
                print("⚠️ Vượt quá tồn kho")
            }
        } else {
            // Thêm mới
            guard product.stock > 0 else {
                print("⚠️ Hết hàng")
                return
            }

            let newItem = CartItem(id: product.id, product: product, quantity: 1)
            cartItems.append(newItem)
            saveToAppStorage()
        }
    }

    func removeFromCart(_ product: Product) {
        cartItems.removeAll { $0.product.id == product.id }
        saveToAppStorage()
    }

    func increaseQuantity(_ item: CartItem) {
        if let index = cartItems.firstIndex(where: { $0.id == item.id }),
           cartItems[index].quantity < item.product.stock {
            cartItems[index].quantity += 1
            saveToAppStorage()
        }
    }

    func decreaseQuantity(_ item: CartItem) {
        if let index = cartItems.firstIndex(where: { $0.id == item.id }) {
            cartItems[index].quantity -= 1
            if cartItems[index].quantity <= 0 {
                cartItems.remove(at: index)
            }
            saveToAppStorage()
        }
    }

    private func saveToAppStorage() {
        if let data = try? JSONEncoder().encode(cartItems) {
            UserDefaults.standard.set(data, forKey: storageKey)
        }
    }

    func deleteCartItem(at offsets: IndexSet) {
    for index in offsets {
        if index < cartItems.count {
            cartItems.remove(at: index)
        }
    }
    saveToAppStorage()
}

 @Published var itemToDelete: CartItem? = nil  // CartItem đang chờ xác nhận xóa

    // Các hàm add/remove/load/save như trước...

    func requestDelete(at indexSet: IndexSet) {
        if let index = indexSet.first, index < cartItems.count {
            itemToDelete = cartItems[index]
        }
    }

    func confirmDelete() {
        guard let item = itemToDelete else { return }
        cartItems.removeAll { $0.id == item.id }
        itemToDelete = nil
        saveToAppStorage()
    }

    func cancelDelete() {
        itemToDelete = nil
    }

    private func loadFromAppStorage() {
        if let data = UserDefaults.standard.data(forKey: storageKey),
           let savedItems = try? JSONDecoder().decode([CartItem].self, from: data) {
            self.cartItems = savedItems
        }
    }
}
