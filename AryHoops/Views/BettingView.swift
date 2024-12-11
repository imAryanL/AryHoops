//
//  BettingView.swift
//  AryHoops
//
//  Created by aryan on 12/10/24.
//

import SwiftUI

// MARK: - Main BettingView
struct BettingView: View {
    // MARK: - State Variables
    @State private var selectedTab = "Upcoming Games"
    @Namespace private var namespace
    let tabs = ["Upcoming Games", "Your Bets"]
    @State private var virtualCurrency: Int = 1000
    @State private var bettingData: [OddsResponse] = []
    @State private var isLoading = true
    @State private var errorMessage: String?
    @State private var bets: [Bet] = [] // Shared bets list

    var body: some View {
        ZStack {
            // Background
            LinearGradient(
                colors: [Color(red: 89/255, green: 96/255, blue: 113/255)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 15) {
                // Top Navigation Bar
                HStack {
                    Image("mango")
                        .resizable()
                        .frame(width: 30, height: 30)
                    Text("AryHoops")
                        .font(.custom("Noteworthy-Bold", size: 20))
                        .foregroundColor(.white)
                    Spacer()
                    Image("userIcon")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 35, height: 35)
                        .clipShape(Circle())
                        .foregroundColor(.white.opacity(0.8))
                }
                .padding(.horizontal)

                // Tab Selection Bar
                HStack(spacing: 9) {
                    ForEach(tabs, id: \.self) { tab in
                        Button(action: {
                            selectedTab = tab
                        }) {
                            Text(tab)
                                .foregroundColor(.white)
                                .font(.system(size: 14))
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(
                                    selectedTab == tab ?
                                    Color.orange : Color.orange.opacity(0.4)
                                )
                                .clipShape(RoundedRectangle(cornerRadius: 15))
                        }
                    }
                }
                .padding(.horizontal)

                // Balance Section
                HStack {
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Your Balance")
                            .font(.system(size: 17))
                            .foregroundColor(.white)
                        HStack(spacing: 5) {
                            Image("coin")
                                .resizable()
                                .frame(width: 20, height: 20)
                            Text("\(virtualCurrency)")
                                .font(.system(size: 20))
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        }
                    }
                    Spacer()
                }
                .padding()
                .background(Color.white.opacity(0.1))
                .cornerRadius(15)
                .padding(.horizontal)

                // Main Content Sections
                ScrollView {
                    VStack(spacing: 30) {
                        if selectedTab == "Upcoming Games" {
                            UpcomingGamesView(
                                bettingData: $bettingData,
                                isLoading: $isLoading,
                                errorMessage: $errorMessage,
                                virtualCurrency: $virtualCurrency,
                                bets: $bets
                            )
                        } else if selectedTab == "Your Bets" {
                            YourBetsView(bets: $bets)
                        }
                    }
                    .padding(.vertical)
                }
                .onAppear {
                    fetchBettingData()
                }
            }
        }
    }

    // Fetch Betting Data
    private func fetchBettingData() {
        isLoading = true
        BettingAPI.shared.fetchBettingData { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    bettingData = data
                    isLoading = false
                case .failure(let error):
                    errorMessage = error.localizedDescription
                    isLoading = false
                }
            }
        }
    }
}

// MARK: - Upcoming Games View
struct UpcomingGamesView: View {
    @Binding var bettingData: [OddsResponse]
    @Binding var isLoading: Bool
    @Binding var errorMessage: String?
    @Binding var virtualCurrency: Int
    @Binding var bets: [Bet]

    var body: some View {
        VStack(spacing: 20) {
            Text("Upcoming Games")
                .font(.headline)
                .foregroundColor(.white)

            if isLoading {
                ProgressView("Loading...")
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
            } else if let errorMessage = errorMessage {
                Text("Error: \(errorMessage)")
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
            } else {
                ForEach(bettingData, id: \.id) { game in
                    BettingRowView(
                        homeTeam: game.homeTeamNickname,
                        awayTeam: game.awayTeamNickname,
                        odds: game.bookmakers.first?.markets.first?.outcomes.map { "\($0.name): \($0.price)" }.joined(separator: ", ") ?? "",
                        commenceTime: game.commenceTime,
                        virtualCurrency: $virtualCurrency,
                        bets: $bets
                    )
                }
            }
        }
        .padding()
        .background(Color.white.opacity(0.1))
        .cornerRadius(15)
    }
}

// MARK: - Your Bets View
struct YourBetsView: View {
    @Binding var bets: [Bet]

    var body: some View {
        VStack(spacing: 20) {
            Text("Your Bets")
                .font(.headline)
                .foregroundColor(.white)

            if bets.isEmpty {
                Text("No bets placed yet.")
                    .foregroundColor(.white.opacity(0.8))
            } else {
                ForEach(bets) { bet in
                    BetRowView(bet: bet)
                }
            }
        }
        .padding()
        .background(Color.white.opacity(0.1))
        .cornerRadius(15)
        .padding(.horizontal)
    }
}

// MARK: - Betting Row View
struct BettingRowView: View {
    let homeTeam: String
    let awayTeam: String
    let odds: String
    let commenceTime: String
    @Binding var virtualCurrency: Int
    @Binding var bets: [Bet]
    @State private var showBetInput = false

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("\(awayTeam) vs \(homeTeam)")
                    .font(.headline)
                    .foregroundColor(.white)
                Text("Odds: \(odds)")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.8))
            }
            Spacer()
            VStack {
                Text(formatDate(from: commenceTime))
                    .font(.footnote)
                    .foregroundColor(.white.opacity(0.8))
                Button(action: {
                    showBetInput = true
                }) {
                    Text("Bet Now")
                        .padding()
                        .background(Color.orange)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
        }
        .padding()
        .background(Color.white.opacity(0.1))
        .cornerRadius(10)
        .sheet(isPresented: $showBetInput) {
            BetInputView(
                homeTeam: homeTeam,
                awayTeam: awayTeam,
                odds: odds,
                commenceTime: commenceTime,
                virtualCurrency: $virtualCurrency,
                bets: $bets
            )
        }
    }

    private func formatDate(from isoDate: String) -> String {
        // Date Formatting Logic
        let isoFormatter = ISO8601DateFormatter()
        if let date = isoFormatter.date(from: isoDate) {
            let formatter = DateFormatter()
            formatter.dateFormat = "E, MMM d 'at' h:mm a"
            return formatter.string(from: date)
        }
        return "Invalid Date"
    }
}

// MARK: - Bet Input View
struct BetInputView: View {
    let homeTeam: String
    let awayTeam: String
    let odds: String
    let commenceTime: String
    @Binding var virtualCurrency: Int
    @Binding var bets: [Bet]
    @State private var betAmount: String = ""
    @State private var errorMessage: String?

    var body: some View {
        ZStack {
            // Background
            LinearGradient(
                colors: [Color(red: 89/255, green: 96/255, blue: 113/255)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text("Place Your Bet")
                    .font(.headline)
                    .foregroundColor(.white)
                Text("\(awayTeam) vs \(homeTeam)")
                    .font(.title2)
                    .foregroundColor(.orange)
                TextField("Enter bet amount", text: $betAmount)
                    .keyboardType(.numberPad)
                    .padding()
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(8)
                    .foregroundColor(.white)
                if let error = errorMessage {
                    Text(error).foregroundColor(.red)
                }
                Button(action: confirmBet) {
                    Text("Confirm Bet")
                        .padding()
                        .background(Color.orange)
                        .cornerRadius(8)
                        .foregroundColor(.white)
                }
            }
            .padding()
        }
    }

    private func confirmBet() {
        guard let amount = Int(betAmount), amount > 0 else {
            errorMessage = "Invalid amount."
            return
        }
        if amount > virtualCurrency {
            errorMessage = "Not enough coins."
        } else {
            virtualCurrency -= amount
            bets.append(Bet(
                homeTeam: homeTeam,
                awayTeam: awayTeam,
                odds: odds,
                amount: amount,
                date: commenceTime,
                status: "Pending"
            ))
        }
    }
}

// MARK: - Bet Model
struct Bet: Identifiable {
    let id = UUID()
    let homeTeam: String
    let awayTeam: String
    let odds: String
    let amount: Int
    let date: String
    var status: String // E.g., "Pending", "Won", "Lost"
}

// MARK: - Bet Row View for Your Bets
struct BetRowView: View {
    let bet: Bet

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("\(bet.awayTeam) vs \(bet.homeTeam)")
                .font(.headline)
                .foregroundColor(.white)

            Text("Odds: \(bet.odds)")
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.8))

            Text("Wagered: \(bet.amount) coins")
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.8))

            Text("Date: \(formatDate(from: bet.date))")
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.8))

            Text("Status: \(bet.status)")
                .font(.subheadline)
                .foregroundColor(
                    bet.status == "Won" ? .green : (bet.status == "Lost" ? .red : .white.opacity(0.8))
                )
        }
        .padding()
        .background(Color.white.opacity(0.1))
        .cornerRadius(10)
    }

    private func formatDate(from isoDate: String) -> String {
        // Date formatting for display purposes
        let isoFormatter = ISO8601DateFormatter()
        if let date = isoFormatter.date(from: isoDate) {
            let formatter = DateFormatter()
            formatter.dateFormat = "E, MMM d 'at' h:mm a"
            return formatter.string(from: date)
        }
        return "Invalid Date"
    }
}

// MARK: - Preview Provider
struct BettingView_Previews: PreviewProvider {
    static var previews: some View {
        BettingView()
    }
}
