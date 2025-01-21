//
//  HomeScreen.swift
//  BackDropCarouselSUI
//
//  Created by Kirill Khomicevich on 21.01.2025.
//

import SwiftUI

struct HomeScreen: View {
    @State private var topInset: CGFloat = .zero
    @State private var scrollOffsetY: CGFloat = 0
    @State private var scrollProgressX: CGFloat = 0
    var body: some View {
        ScrollView(.vertical) {
            LazyVStack(spacing: 15) {
                headerView()
                makeCarousel()
                    .zIndex(-1)
            }
        }
        .safeAreaPadding(15)
        .preferredColorScheme(.dark)
        
        .background {
            Rectangle()
                .fill(.black.gradient)
                .scaleEffect(-1)
                .ignoresSafeArea()
        }
        .onScrollGeometryChange(for: ScrollGeometry.self) {
            $0
        } action: { oldValue, newValue in
            topInset = newValue.contentInsets.top + 100
            scrollOffsetY = newValue.contentOffset.y + newValue.contentInsets.top
        }

    }

    @ViewBuilder
    func headerView() -> some View {
        HStack {
            Image(systemName: "xbox.logo")
            VStack(alignment: .leading, spacing: 6, content: {
                Text("Hoki Apps")
                    .font(.callout)
                    .fontWeight(.semibold)
            })
            Spacer()
            Image(systemName: "square.and.arrow.up.circle.fill")
                .font(.largeTitle)
                .foregroundStyle(.white)
            Image(systemName: "bell.circle.fill")
                .font(.largeTitle)
                .foregroundStyle(.white)
        }
        
        .padding(.bottom, 15)
    }

    @ViewBuilder
    func makeCarousel() -> some View {
        let spacing = 10.0
        ScrollView(.horizontal) {
            LazyHStack(spacing: spacing) {
                ForEach(ImageModel.imageModels) { model in
                    Image(model.image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .containerRelativeFrame(.horizontal)
                        .frame(height: 380)
                        .clipShape(.rect(cornerRadius: 10))
                        .shadow(color: .black.opacity(0.4), radius: 5, x: 5, y: 5)
                }
            }
            .scrollTargetLayout()
        }
        .frame(height: 380)
        .background(backdropCarouselView())
        .scrollIndicators(.hidden)
        .scrollTargetBehavior(.viewAligned(limitBehavior: .always))
        .onScrollGeometryChange(for: CGFloat.self) { geometry in
            let offsetX = geometry.contentOffset.x + geometry.contentInsets.leading
            let width = geometry.containerSize.width + spacing
            
            return offsetX / width
        } action: { oldValue, newValue in
            let maxCount = CGFloat(ImageModel.imageModels.count - 1)
            scrollProgressX = min(max(newValue, 0), maxCount)
        }


    }
    
    @ViewBuilder
    func backdropCarouselView() -> some View {
        GeometryReader { geometry in
            let size = geometry.size

            ZStack {
                ForEach(ImageModel.imageModels.reversed()) { model in
                    let indexModel = CGFloat(ImageModel.imageModels.firstIndex { $0.id == model.id } ?? 0) + 1
                    backdropImage(for: model.image, size: size, indexModel: indexModel)
                }
            }
            .compositingGroup()
            .blur(radius: 30, opaque: true)
            .overlay {
                Rectangle()
                    .fill(Color.black.opacity(0.35))
            }
            .mask {
                Rectangle()
                    .fill(
                        LinearGradient(
                            colors: [
                                .black,
                                .black,
                                .black,
                                .black,
                                .black.opacity(0.5),
                                .clear
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
            }
        }
        .containerRelativeFrame(.horizontal)
        .padding(.bottom, -90)
        .padding(.top, -topInset)
        .offset(y: scrollOffsetY < 0 ? scrollOffsetY : 0)
    }

    @ViewBuilder
    private func backdropImage(for imageName: String, size: CGSize, indexModel: CGFloat) -> some View {
        Image(imageName)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: size.width, height: size.height)
            .clipped()
            .opacity(indexModel - scrollProgressX) // Логика прозрачности
    }

}
#Preview {
    HomeScreen()
}
