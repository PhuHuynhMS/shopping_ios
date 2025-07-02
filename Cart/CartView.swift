struct CartView: View {
    @State private var cartItems: [CartItem] = [
        CartItem(id: "1", name: "Áo thun", quantity: 5),
        CartItem(id: "2", name: "Quần jean", quantity: 3),
        CartItem(id: "3", name: "Giày sneaker", quantity: 1)
    ]
    
    @State private var stockErrors: [StockError] = []
    @State private var isProcessing = false

    var body: some View {
        VStack {
            List {
                Section(header: Text("Giỏ hàng")) {
                    ForEach(cartItems) { item in
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Text(item.name)
                                    .font(.headline)
                                Spacer()
                                Text("Số lượng: \(item.quantity)")
                            }

                            if let error = stockErrors.first(where: { $0.id == item.id }) {
                                Text(error.errorMessage)
                                    .font(.caption)
                                    .foregroundColor(.red)
                                    .padding(.top, 2)
                            }
                        }
                        .padding(8)
                        .background(
                            stockErrors.contains(where: { $0.id == item.id }) ?
                            Color.red.opacity(0.1) : Color.clear
                        )
                        .cornerRadius(8)
                    }
                }
            }
            
            Button(action: {
                Task {
                    await handlePay()
                }
            }) {
                Text(isProcessing ? "Đang xử lý..." : "Thanh toán")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(isProcessing ? Color.gray : Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .disabled(isProcessing)
            .padding()
        }
        .navigationTitle("Giỏ hàng")
    }

    func handlePay() async {
        isProcessing = true
        defer { isProcessing = false }

        let responseErrors: [StockError] = await simulateCreateOrder(cart: cartItems)

        if responseErrors.isEmpty {
            stockErrors = []
            print("✅ Đặt hàng thành công")
        } else {
            stockErrors = responseErrors
        }
    }

    func simulateCreateOrder(cart: [CartItem]) async -> [StockError] {
        try? await Task.sleep(nanoseconds: 1_000_000_000)

        // Giả lập trả về lỗi cho một vài sản phẩm
        return [
            StockError(id: "1", quantity: 5, stock: 2),
            StockError(id: "2", quantity: 3, stock: 1)
        ]
    }
}
