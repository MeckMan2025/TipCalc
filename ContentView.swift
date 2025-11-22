import SwiftUI

// MARK: - Meckman Design System V4 Colors
extension Color {
    static let meckmanBlack = Color(red: 0.0, green: 0.0, blue: 0.0)
    static let meckmanCharcoal = Color(red: 42/255, green: 42/255, blue: 42/255)
    static let meckmanTan = Color(red: 1.0, green: 242/255, blue: 204/255)
    static let meckmanRed = Color(red: 204/255, green: 0.0, blue: 0.0)
    static let meckmanLightGray = Color(red: 204/255, green: 204/255, blue: 204/255)
}

struct ContentView: View {
    // MARK: - State
    @State private var checkAmount = 0.0
    @State private var numberOfPeople = 2
    @State private var tipPercentage = 20
    @FocusState private var amountIsFocused: Bool
    
    // MARK: - Data
    let tipPercentages = [10, 15, 20, 25, 0]
    
    // MARK: - Computed Properties
    var totalPerPerson: Double {
        let peopleCount = Double(numberOfPeople)
        let tipSelection = Double(tipPercentage)
        
        let tipValue = checkAmount / 100 * tipSelection
        let grandTotal = checkAmount + tipValue
        let amountPerPerson = grandTotal / peopleCount
        
        return amountPerPerson
    }
    
    var totalAmount: Double {
        let tipSelection = Double(tipPercentage)
        let tipValue = checkAmount / 100 * tipSelection
        return checkAmount + tipValue
    }
    
    var tipValue: Double {
        let tipSelection = Double(tipPercentage)
        return checkAmount / 100 * tipSelection
    }
    
    // MARK: - Initializer for Navigation Bar Appearance
    init() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(Color.meckmanBlack)
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            ZStack {
                // Background: The environment. Endless space.
                Color.meckmanBlack
                    .ignoresSafeArea()
                
                Form {
                    // MARK: - Input Section
                    Section {
                        HStack {
                            Text("Bill Amount")
                                .foregroundColor(.meckmanLightGray)
                            Spacer()
                            TextField("Amount", value: $checkAmount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                                .keyboardType(.decimalPad)
                                .focused($amountIsFocused)
                                .multilineTextAlignment(.trailing)
                                .foregroundColor(.white)
                                .tint(.meckmanTan)
                        }
                        .listRowBackground(Color.meckmanCharcoal)
                        
                        Picker("Number of People", selection: $numberOfPeople) {
                            ForEach(2..<101) {
                                Text("\($0) people").tag($0)
                            }
                        }
                        .pickerStyle(.navigationLink)
                        .foregroundColor(.meckmanLightGray)
                        .listRowBackground(Color.meckmanCharcoal)
                    } header: {
                        Text("Input")
                            .foregroundColor(.meckmanLightGray)
                    }
                    
                    // MARK: - Tip Percentage Section
                    Section {
                        Picker("Tip Percentage", selection: $tipPercentage) {
                            ForEach(tipPercentages, id: \.self) {
                                Text($0, format: .percent)
                            }
                        }
                        .pickerStyle(.segmented)
                        .colorMultiply(.meckmanTan) // Tinting the segment control
                        .listRowBackground(Color.meckmanCharcoal)
                    } header: {
                        Text("How much tip do you want to leave?")
                            .foregroundColor(.meckmanLightGray)
                    }
                    
                    // MARK: - Calculations Section
                    Section {
                        // Tip Amount
                        HStack {
                            Text("Tip Amount")
                                .foregroundColor(.meckmanLightGray)
                            Spacer()
                            Text(tipValue, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                                .foregroundColor(.white)
                        }
                        .listRowBackground(Color.meckmanCharcoal)
                        
                        // Grand Total
                        HStack {
                            Text("Grand Total")
                                .foregroundColor(.meckmanLightGray)
                            Spacer()
                            Text(totalAmount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                                .foregroundColor(.white)
                        }
                        .listRowBackground(Color.meckmanCharcoal)
                        
                        // Amount Per Person - CRITICAL: Red
                        HStack {
                            Text("Amount Per Person")
                                .foregroundColor(.meckmanLightGray)
                            Spacer()
                            Text(totalPerPerson, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.meckmanRed)
                        }
                        .listRowBackground(Color.meckmanCharcoal)
                        
                    } header: {
                        Text("Results")
                            .foregroundColor(.meckmanLightGray)
                    }
                }
                .scrollContentBackground(.hidden) // Hides default system background
                .background(Color.meckmanBlack) // Ensures form background is black
            }
            .navigationTitle("Tip Splitter V4")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                if amountIsFocused {
                    Button("Done") {
                        amountIsFocused = false
                    }
                    .foregroundColor(.meckmanTan)
                }
            }
            .scrollDismissesKeyboard(.interactively)
        }
        .preferredColorScheme(.dark) // Force dark mode for system elements
    }
}

#Preview {
    ContentView()
}
