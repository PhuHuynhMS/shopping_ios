import SwiftUI

struct CartView: View {
    @StateObject var viewModel = CartViewModel()
    @State private var token = "your_jwt_token_here"

    var body: some View {
        NavigationView {
            VStack {
                if viewModel.cartItems.isEmpty {
                    Text("🛒 Giỏ hàng trống")
                        .font(.title3)
                        .foregroundColor(.gray)
                } else {
                    List {
                        ForEach(viewModel.cartItems) { item in
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Text(item.name)
                                        .font(.headline)
                                    Spacer()
                                    HStack {
                                        Button(action: {
                                            viewModel.decreaseQuantity(for: item)
                                        }) {
                                            Image(systemName: "minus.circle")
                                        }

                                        Text("\(item.quantity)")
                                            .padding(.horizontal, 8)

                                        Button(action: {
                                            viewModel.increaseQuantity(for: item)
                                        }) {
                                            Image(systemName: "plus.circle")
                                        }
                                    }
                                }

                                if item.isOverStock {
                                    Text("⚠️ Vượt quá số lượng trong kho")
                                        .font(.caption)
                                        .foregroundColor(.red)
                                }
                            }
                            .padding(.vertical, 4)
                        }
                        .onDelete(perform: viewModel.removeItem)
                    }
                }

                if viewModel.isLoading {
                    ProgressView("Đang đặt hàng...")
                        .padding()
                }

                if let orderId = viewModel.orderId {
                    Text("✅ Đặt hàng thành công với mã: \(orderId)")
                        .foregroundColor(.green)
                        .padding(.top, 8)
                }

                if let error = viewModel.errorMessage {
                    Text("❌ \(error)")
                        .foregroundColor(.red)
                        .padding(.top, 8)
                }

                Button("Đặt hàng") {
                    viewModel.submitOrder(token: token)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(12)
                .padding(.horizontal)
            }
            .navigationTitle("Giỏ hàng")
            .onAppear {
                // Dữ liệu demo
                viewModel.cartItems = [
                    CartItem(productId: "p1", name: "Product A", quantity: 3),
                    CartItem(productId: "p2", name: "Product B", quantity: 12)
                ]
            }
        }
    }
}
