import SwiftUI

struct OnboardingView: View {
    @ObservedObject private var viewModel = OnboardingViewModel()

    var body: some View {
        VStack {
            TabView(selection: $viewModel.currentPage) {
                ForEach(Array(viewModel.pages.enumerated()), id: \.offset) { index, page in
                    VStack(spacing: 20) {
                        Image(systemName: page.imageName)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                            .padding()

                        Text(page.title)
                            .font(.title)
                            .bold()

                        Text(page.description)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                    .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))

            Spacer()

            Button(action: {
                viewModel.next()
            }) {
                Text(viewModel.currentPage == viewModel.pages.count - 1 ? "Bắt đầu" : "Tiếp theo")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .padding(.horizontal)
            }
            .padding(.bottom, 30)
        }
    }
}
