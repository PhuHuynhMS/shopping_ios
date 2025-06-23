import SwiftUI

struct CartView: View {
    @ObservedObject var cartVM: CartViewModel

    var body: some View {
        List {
            ForEach(cartVM.cartItems) { item in
                HStack {
                    VStack(alignment: .leading) {
                        Text(item.product.name)
                        Text("Giá: \(Int(item.product.price))đ")
                        Text("Số lượng: \(item.quantity)")
                    }
                    Spacer()
                    HStack {
                        Button("-") {
                            cartVM.decreaseQuantity(item)
                        }
                        Button("+") {
                            cartVM.increaseQuantity(item)
                        }
                        .disabled(item.quantity >= item.product.stock)
                    }
                }
            }
            .onDelete(perform: cartVM.requestDelete) // Gọi xác nhận thay vì xóa ngay
        }
        .navigationTitle("Giỏ hàng")
        .toolbar {
            EditButton()
        }
        .alert("Bạn có chắc muốn xóa sản phẩm này?",
               isPresented: Binding<Bool>(
                get: { cartVM.itemToDelete != nil },
                set: { value in
                    if !value {
                        cartVM.cancelDelete()
                    }
                }
               ),
               actions: {
                   Button("Hủy", role: .cancel) {
                       cartVM.cancelDelete()
                   }
                   Button("Đồng ý", role: .destructive) {
                       cartVM.confirmDelete()
                   }
               },
               message: {
                   if let item = cartVM.itemToDelete {
                       Text(item.product.name)
                   }
               }
        )
    }
}
