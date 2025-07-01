import SwiftUI

struct OrderDetailView: View {
    let order: Order

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("🧾 Chi tiết đơn hàng")
                .font(.title2)
                .bold()
            
            Text("🛒 Sản phẩm: \(order.productName)")
            Text("📦 Số lượng: \(order.quantity)")
            Text("💵 Tổng tiền: $\(order.totalPrice, specifier: "%.2f")")
            Text("📅 Ngày đặt: \(order.orderDate.formatted(date: .abbreviated, time: .shortened))")
            Text("🚚 Trạng thái: \(order.status)")
                .foregroundColor(order.status == "Delivered" ? .green : .orange)

            Spacer()
        }
        .padding()
        .navigationTitle("Đơn hàng #\(order.id)")
    }
}
