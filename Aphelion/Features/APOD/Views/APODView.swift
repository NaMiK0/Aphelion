import SwiftUI
import SwiftData

struct APODView: View {
    @State private var viewModel = APODViewModel(client: NASAClient(), selectDate: Date())
    @State private var dragOffset: CGFloat = 0
    @State private var showDatePicker: Bool = false
    @State private var selectedDate: Date = Date()
    @Environment(\.modelContext) private var favoriteContext
    @Query private var favorites: [FavoriteAPOD]
    private var isFavorite: Bool { favorites.contains(where: { $0.date == viewModel.currentDateString }) }
    let startDate = Calendar.current.date(from: DateComponents(year: 1995, month: 6, day: 16))!
    
    init(initialDate: Date = Date()) {
        _viewModel = State(wrappedValue: APODViewModel(client: NASAClient(), selectDate: initialDate))
    }
    
    
    var body: some View {
        NavigationStack {
            ScrollView{
                VStack{
                    if !viewModel.isLoading {
                        if let apod = viewModel.apod {
                            CachedAsyncImage(url: URL(string: apod.url)){ image in
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(maxWidth: .infinity, maxHeight: 400)
                                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                                    .shadow(color: Color(red: 0.3, green: 0.1, blue: 0.8).opacity(0.5), radius: 15)
                            } placeholder: {
                                Text("Фотография грузится...")
                                    .foregroundStyle(Color.blue)
                                    .font(.title2)
                                    .padding()
                            }
                            .padding()
                            
                            VStack{
                                HStack{
                                    Text(viewModel.formattedDate)
                                        .foregroundStyle(Color.gray)
                                        .font(.footnote)
                                    Spacer()
                                }
                                
                                HStack{
                                    if let author = apod.copyright {
                                        Text("Автор: \(author)")
                                            .foregroundStyle(Color.gray)
                                            .font(.footnote)
                                        Spacer()
                                    }
                                }
                                
                            }
                            .padding([.leading], 16)
                            
                            
                            Text(apod.title)
                                .foregroundStyle(Color.indigo)
                                .font(.title)
                                .padding()
                            
                            Text(apod.explanation)
                                .font(.title3)
                                .padding()
                        }
                    }
                }
                .task {
                    await viewModel.fetchAPOD()
                }
                .offset(x: dragOffset)
                .simultaneousGesture(DragGesture(minimumDistance: 20, coordinateSpace: .global)
                    .onChanged{ value in
                        dragOffset = value.translation.width
                    }
                    .onEnded { value in
                        if value.translation.width < -150 {
                            withAnimation(.easeInOut(duration: 0.6)) {
                                viewModel.goToNextDay()
                            }
                        } else if value.translation.width > 150 {
                            withAnimation(.easeInOut(duration: 0.6)) {
                                viewModel.goToPreviousDay()
                            }
                        }
                        withAnimation(.easeOut(duration: 0.6)) {
                            dragOffset = 0
                        }
                    }
                                     
                                     
                                     
                )
            }
            .preferredColorScheme(ColorScheme.dark)
            .overlay(alignment: dragOffset > 0 ? .leading : .trailing) {
                if dragOffset != 0 {
                    let intensity = min(abs(dragOffset) / 170, 1.0)
                    Rectangle()
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color(red: 0.6, green: 0.3, blue: 1.0).opacity(0.7 * intensity),
                                    Color(red: 0.3, green: 0.1, blue: 0.8).opacity(0.3 * intensity),
                                    .clear
                                ],
                                startPoint: dragOffset > 0 ? .leading : .trailing,
                                endPoint: dragOffset > 0 ? .trailing : .leading
                            )
                        )
                        .frame(width: 80)
                        .allowsHitTesting(false)
                }
            }
            .overlay{
                if viewModel.isLoading {
                    ProgressView()
                        .frame(width: 35, height: 35)
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button{
                        showDatePicker.toggle()
                    } label: {
                        Image(systemName: "calendar")
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button{
                        if isFavorite {
                            if let existing = favorites.first(where: { $0.date == viewModel.currentDateString }) {
                                favoriteContext.delete(existing)
                                try? favoriteContext.save()
                            }
                        } else if let favoriteAPOD = viewModel.apod {
                            let favorite = FavoriteAPOD(title: favoriteAPOD.title, explanation: favoriteAPOD.explanation, imageURL: favoriteAPOD.url, date: favoriteAPOD.date)
                            favoriteContext.insert(favorite)
                            try? favoriteContext.save()
                        }
                    } label: {
                        Image(systemName: isFavorite ? "star.fill" : "star")
                            .foregroundStyle(isFavorite ? Color.indigo : .white)
                    }
                }
            }
            .sheet(isPresented: $showDatePicker) {
                NavigationStack{
                    DatePicker("Выберите дату публикации:",
                               selection: $selectedDate,
                               in: startDate...Date(),
                               displayedComponents: .date
                    )
                    .onAppear(){
                        selectedDate = viewModel.currentDate
                    }
                    .datePickerStyle(.graphical)
                    .toolbar{
                        ToolbarItem(placement: .topBarTrailing) {
                            Button{
                                Task{
                                    viewModel.currentDate = selectedDate
                                    await viewModel.fetchAPOD()
                                    showDatePicker.toggle()
                                }
                            } label: {
                                Text("Применить")
                            }
                        }
                        ToolbarItem(placement: .topBarLeading) {
                            Button{
                                Task{
                                    showDatePicker.toggle()
                                }
                            } label: {
                                Text("Отмена")
                            }
                        }
                    }
                    
                }
                .presentationDetents([.medium])
                
            }
        }
    }
}

