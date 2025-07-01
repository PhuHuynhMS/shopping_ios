struct ProfileView: View {
    @StateObject var viewModel = ProfileViewModel()
    @State private var selectedOrder: Order?

    let userId = "user-123"              // ví dụ
    let token = "eyJhbGciOi..."          // ví dụ token

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 16) {
                Text("👤 Hồ sơ người dùng")
                    .font(.title)
                    .bold()

                if let error = viewModel.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                }

                Divider()
                
                Text("🧾 Đơn hàng của bạn")
                    .font(.headline)

                if viewModel.isLoading {
                    ProgressView("Đang tải đơn hàng...")
                } else {
                    List(viewModel.orders) { order in
                        Button {
                            selectedOrder = order
                        } label: {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(order.productName)
                                        .font(.headline)
                                    Text("Trạng thái: \(order.status)")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                                Spacer()
                                Text("$\(order.totalPrice, specifier: "%.2f")")
                                    .bold()
                            }
                        }
                    }
                    .listStyle(.plain)
                }

                Spacer()
            }
            .padding()
            .navigationDestination(item: $selectedOrder) { order in
                OrderDetailView(order: order)
            }
            .onAppear {
                viewModel.fetchOrders(for: userId, token: token)
            }
        }
    }
}
