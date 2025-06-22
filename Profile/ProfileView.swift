import SwiftUI

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Avatar
                if let url = viewModel.user.avatarURL {
                    Image(url)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120, height: 120)
                        .clipShape(Circle())
                } else {
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .frame(width: 120, height: 120)
                        .foregroundColor(.gray)
                }

                // Thông tin
                Text(viewModel.user.name)
                    .font(.title2)
                    .bold()

                Text(viewModel.user.email)
                    .foregroundColor(.secondary)

                // Nút
                Button("Đăng xuất") {
                    viewModel.logout()
                }
                .foregroundColor(.red)
                .padding(.top)

                Spacer()
            }
            .padding()
            .navigationTitle("Hồ sơ cá nhân")
        }
    }
}
