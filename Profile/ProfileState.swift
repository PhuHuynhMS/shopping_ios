import SwiftUI

class ProfileViewModel: ObservableObject {
    @Published var user: User = User(
        id: UUID(),
        name: "Nguyễn Văn A",
        email: "vana@example.com",
        avatarURL: nil
    )

    // Hàm cập nhật thông tin (demo)
    func updateName(to newName: String) {
        user.name = newName
    }

    func logout() {
        // Gửi thông báo logout hoặc reset trạng thái
    }
}
