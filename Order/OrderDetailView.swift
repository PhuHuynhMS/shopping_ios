import SwiftUI

struct OrderListView: View {
    @StateObject private var viewModel = OrderViewModel()

    var body: some View {
        NavigationView {
            Group {
                if viewModel.isLoading {
                    ProgressView("Đang tải đơn hàng...")
                } else if let error = viewModel.errorMessage {
                    VStack {
                        Text("❌ \(error)")
                            .foregroundColor(.red)
                        Button("Thử lại") {
                            viewModel.fetchOrders()
                        }
                    }
                } else {
                    List(viewModel.orders) { order in
                        NavigationLink(destination: OrderDetailView(order: order)) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Mã đơn: \(order.id.uuidString.prefix(8))")
                                    .font(.headline)
                                Text(order.createdAt, style: .date)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                Text("Tổng tiền: \(Int(order.total))đ")
                                    .fontWeight(.semibold)
                                Text("Trạng thái: \(order.status.rawValue)")
                                    .foregroundColor(.blue)
                                    .font(.footnote)
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }
            }
            .navigationTitle("Đơn hàng của tôi")
            .onAppear {
                viewModel.fetchOrders()
            }
        }
    }
}
