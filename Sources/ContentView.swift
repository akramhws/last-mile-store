import SwiftUI

struct Product: Identifiable {
    let id = UUID()
    let name: String
    let emoji: String
    let price: String
}

struct ContentView: View {
    let products = AppConfig.products.map { Product(name: $0.name, emoji: $0.emoji, price: $0.price) }
    @State private var cartCount = 0
    @State private var searchText = ""

    var filtered: [Product] {
        searchText.isEmpty ? products : products.filter { $0.name.contains(searchText) }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 14) {
                    ForEach(filtered) { p in
                        ProductCard(product: p) { cartCount += 1 }
                    }
                }
                .padding()
            }
            .navigationTitle(AppConfig.storeName)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    ZStack(alignment: .topTrailing) {
                        Image(systemName: "cart")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(AppConfig.primaryColor)
                        if cartCount > 0 {
                            Text("\\(cartCount)")
                                .font(.system(size: 9, weight: .bold))
                                .foregroundColor(.white)
                                .frame(width: 16, height: 16)
                                .background(AppConfig.accentColor)
                                .clipShape(Circle())
                                .offset(x: 8, y: -6)
                        }
                    }
                }
            }
        }
        .searchable(text: $searchText, prompt: "ابحث عن منتج...")
        .environment(\\.layoutDirection, .rightToLeft)
    }
}

struct ProductCard: View {
    let product: Product
    let onAdd: () -> Void
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(AppConfig.primaryColor.opacity(0.1))
                    .aspectRatio(1, contentMode: .fit)
                Text(product.emoji).font(.system(size: 44))
            }
            Text(product.name)
                .font(.system(size: 13, weight: .semibold, design: AppConfig.fontDesign))
                .lineLimit(1)
            HStack {
                Text("\\(product.price) \\(AppConfig.storeCurrency)")
                    .font(.system(size: 13, weight: .bold, design: AppConfig.fontDesign))
                    .foregroundColor(AppConfig.primaryColor)
                Spacer()
                Button(action: onAdd) {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 22))
                        .foregroundColor(AppConfig.primaryColor)
                }
            }
        }
        .padding(12)
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.06), radius: 8, y: 2)
    }
}
