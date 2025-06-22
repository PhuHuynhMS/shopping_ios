import SwiftUI

class OnboardingState: ObservableObject {
    // Danh sách các trang giới thiệu
    @Published var pages: [OnboardingModel] = []

    // Trang hiện tại
    @Published var currentPage: Int = 0

    // Dùng để điều hướng sang MainApp sau khi hoàn tất
    @AppStorage("hasSeenOnboarding") var hasSeenOnboarding: Bool = false

    init() {
        setupPages()
    }

    private func setupPages() {
        self.pages = [
            OnboardingModel(title: "Chào mừng", description: "Khám phá trải nghiệm mua sắm thông minh.", imageName: "cart"),
            OnboardingModel(title: "Tìm kiếm dễ dàng", description: "Tìm sản phẩm bạn cần chỉ với vài cú chạm.", imageName: "magnifyingglass"),
            OnboardingModel(title: "Thanh toán nhanh", description: "Thanh toán an toàn và nhanh chóng.", imageName: "creditcard")
        ]
    }

    // Chuyển sang trang tiếp theo hoặc kết thúc
    func next() {
        if currentPage < pages.count - 1 {
            currentPage += 1
        } else {
            completeOnboarding()
        }
    }

    func completeOnboarding() {
        hasSeenOnboarding = true
    }
}
