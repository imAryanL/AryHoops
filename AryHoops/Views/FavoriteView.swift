//
//  FavoriteView.swift
//  AryHoops
//
//  Created by aryan on 12/9/24.
//

import SwiftUI

struct FavoriteView: View {
    @StateObject private var viewModel = FavoriteViewModel()
    @State private var searchText = ""
    
    var filteredTeams: [FavoriteTeam] {
        if searchText.isEmpty {
            return viewModel.allTeams
        }
        return viewModel.allTeams.filter { $0.name.lowercased().contains(searchText.lowercased()) }
    }
    
    var body: some View {
        ZStack {
            // MARK: - Background
            LinearGradient(
                colors: [Color(red: 89/255, green: 96/255, blue: 113/255)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 15) {
                // MARK: - Top Navigation Bar
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
                
                if !viewModel.isTeamSelected {
                    // MARK: - Team Selection View
                    VStack(spacing: 20) {
                        Text("Select Your Favorite Team")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        SearchBar(text: $searchText)
                        
                        if viewModel.isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .scaleEffect(1.5)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                        } else if let error = viewModel.errorMessage {
                            VStack(spacing: 10) {
                                Text("Error loading data")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                Text(error)
                                    .font(.subheadline)
                                    .foregroundColor(.white.opacity(0.8))
                                Button("Retry") {
                                    Task {
                                        await viewModel.fetchTeamData()
                                    }
                                }
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.white.opacity(0.2))
                                .cornerRadius(10)
                            }
                            .padding()
                        } else {
                            ScrollView {
                                LazyVStack(spacing: 12) {
                                    ForEach(filteredTeams) { team in
                                        TeamSelectionRow(team: team)
                                            .onTapGesture {
                                                viewModel.selectTeam(team)
                                            }
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                    }
                } else if let team = viewModel.selectedTeam {
                    // MARK: - Team Detail View
                    TeamDetailView(team: team) {
                        viewModel.clearSelection()
                    }
                }
            }
        }
    }
}

struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.white.opacity(0.8))
            
            TextField("Search teams...", text: $text)
                .textFieldStyle(PlainTextFieldStyle())
                .foregroundColor(.white)
                .accentColor(.white)
                .placeholder(when: text.isEmpty) {
                    Text("Search teams...")
                        .foregroundColor(.white.opacity(0.5))
                }
        }
        .padding(10)
        .background(Color.white.opacity(0.15))
        .cornerRadius(10)
        .padding(.horizontal)
    }
}

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {
        
        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}

struct TeamSelectionRow: View {
    let team: FavoriteTeam
    
    var logoName: String {
        return "\(team.imageAssetName)-logo"
    }
    
    var body: some View {
        HStack(spacing: 15) {
            Image(logoName)
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
                .background(Circle().fill(Color.white.opacity(0.2)))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(team.name)
                    .font(.headline)
                    .foregroundColor(.white)
                
                Text(team.conference + " Conference")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.8))
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.white.opacity(0.8))
        }
        .padding()
        .background(Color.white.opacity(0.1))
        .cornerRadius(15)
    }
}

struct TeamDetailView: View {
    let team: FavoriteTeam
    let onBack: () -> Void
    
    var logoName: String {
        return "\(team.imageAssetName)-logo"
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Back Button
                HStack {
                    Button(action: onBack) {
                        HStack {
                            Image(systemName: "chevron.left")
                            Text("Back")
                        }
                        .foregroundColor(.white)
                    }
                    Spacer()
                }
                .padding(.horizontal)
                
                // Team Logo
                Image(logoName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)
                    .background(Circle().fill(Color.white.opacity(0.2)))
                
                // Team Info
                VStack(spacing: 15) {
                    Text(team.name)
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text("\(team.conference) Conference - \(team.division) Division")
                        .font(.headline)
                        .foregroundColor(.white.opacity(0.8))
                    
                    // Stats Grid
                    HStack(spacing: 20) {
                        StatBox(title: "Wins", value: "\(team.wins)")
                        StatBox(title: "Losses", value: "\(team.losses)")
                        StatBox(title: "Win %", value: String(format: "%.3f", team.winPercentage))
                    }
                    
                    // Current Streak
                    VStack(spacing: 8) {
                        Text("Current Streak")
                            .font(.headline)
                            .foregroundColor(.white.opacity(0.8))
                        Text(team.streak)
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(team.streak.hasPrefix("Won") ? .green : .red)
                    }
                    .padding()
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(15)
                    
                    // Last 10 Games
                    VStack(spacing: 10) {
                        StatBox(title: "Last 10 Games", value: team.lastTenGames)
                    }
                    .padding(.horizontal)
                }
                .padding()
            }
        }
    }
}

struct StatBox: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack {
            Text(title)
                .font(.caption)
                .foregroundColor(.white.opacity(0.8))
            Text(value)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.white.opacity(0.1))
        .cornerRadius(10)
    }
}

struct FavoriteView_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteView()
    }
}
