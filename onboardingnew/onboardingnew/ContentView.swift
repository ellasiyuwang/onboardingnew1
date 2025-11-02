
//
//  ContentView.swift
//  Exercise3
//
//  Created by Ella Wang on 9/11/25.
//

import SwiftUI

// Data models

struct Award: Identifiable {
    let id = UUID()
    let title: String
    let emoji: String
    let threshold: Int
}

struct OnboardingCard: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let emoji: String
}

// Reusable button sprite

struct SpriteButtonLabel: View {
    let text: String
    let systemImage: String

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: systemImage)
            Text(text).bold()
        }
        .font(.headline)
        .padding(.horizontal, 18).padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(LinearGradient(colors: [.blue, .purple],
                                     startPoint: .leading, endPoint: .trailing))
        )
        .foregroundStyle(.white)
        .shadow(radius: 4, y: 2)
    }
}

// Title screen

struct TitleScreen: View {
    var body: some View {
        ZStack {
            LinearGradient(colors: [.purple.opacity(0.25), .pink.opacity(0.25)],
                           startPoint: .top, endPoint: .bottom)
            .ignoresSafeArea()

            VStack(spacing: 24) {
                Image(systemName: "sparkles")
                    .font(.system(size: 64))
                    .foregroundStyle(.blue)

                Text("The Best Notes App")
                    .font(.system(size: 36, weight: .bold))

                Text("Capture ideas. Grow streaks. ✨")
                    .foregroundColor(.secondary)

                NavigationLink {
                    OnboardingView()
                } label: {
                    SpriteButtonLabel(text: "Start Onboarding",
                                      systemImage: "arrow.right.circle.fill")
                }

                NavigationLink {
                    LoginView()
                } label: {
                    SpriteButtonLabel(text: "Log In",
                                      systemImage: "person.crop.circle.fill")
                }
            }
            .padding()
        }
    }
}

// Onboarding flow

struct OnboardingView: View {
    @State private var page = 0

    private let pages = [
        OnboardingCard(title: "Welcome to The Best Notes App",
            subtitle: "A simple, friendly space to capture ideas.", emoji: "✨"),
        OnboardingCard(title: "Stay Organized", subtitle: "Tag and color-code your notes.", emoji: "🗂️"),
        OnboardingCard(title: "Sync Everywhere", subtitle: "Your ideas on all devices.", emoji: "☁️"),
        OnboardingCard(title: "Build a Streak", subtitle: "Write a little every day.", emoji: "🔥")
    ]

    var body: some View {
        ZStack {
            LinearGradient(colors: [.mint.opacity(0.25), .blue.opacity(0.2)],
                           startPoint: .topLeading, endPoint: .bottomTrailing)
            .ignoresSafeArea()

            VStack(spacing: 24) {
                TabView(selection: $page) {
                    ForEach(Array(pages.enumerated()), id: \.offset) { index, card in
                        VStack(spacing: 16) {
                            Text(card.emoji).font(.system(size: 80))
                            Text(card.title).font(.title.bold())
                            Text(card.subtitle)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                        }
                        .tag(index)
                    }
                }
                .tabViewStyle(.page)
                .indexViewStyle(.page(backgroundDisplayMode: .always))
                .frame(maxHeight: 420)

                HStack(spacing: 12) {
                    if page > 0 {
                        Button { withAnimation { page -= 1 } } label: {
                            SpriteButtonLabel(text: "Back",
                                              systemImage: "chevron.left.circle.fill")
                        }
                    }
                    Spacer()
                    if page < pages.count - 1 {
                        Button { withAnimation { page += 1 } } label: {
                            SpriteButtonLabel(text: "Next",
                                              systemImage: "chevron.right.circle.fill")
                        }
                    } else {
                        NavigationLink {
                            LoginView()
                        } label: {
                            SpriteButtonLabel(text: "Get Started",
                                              systemImage: "checkmark.seal.fill")
                        }
                    }
                }
                .padding(.horizontal)
            }
            .padding(.bottom, 24)
        }
        .navigationTitle("Onboarding")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// Login page

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var showError = false

    var body: some View {
        ZStack {
            LinearGradient(colors: [.orange.opacity(0.22), .pink.opacity(0.22)],
                           startPoint: .top, endPoint: .bottom)
            .ignoresSafeArea()

            VStack(spacing: 20) {
                Image(systemName: "person.crop.circle.badge.checkmark")
                    .font(.system(size: 64))
                    .foregroundStyle(.blue)

                Text("Welcome back")
                    .font(.title.bold())

                VStack(spacing: 12) {
                    TextField("Email", text: $email)
                        .textContentType(.emailAddress)
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 14).fill(.thinMaterial))

                    SecureField("Password", text: $password)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 14).fill(.thinMaterial))
                }
                .padding(.horizontal)

                if showError {
                    Text("Please enter a valid email and a password with 6+ characters.")
                        .foregroundColor(.red)
                        .font(.footnote)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }

                NavigationLink {
                    HomeView()
                } label: {
                    SpriteButtonLabel(text: "Log In", systemImage: "lock.open.fill")
                }
                .simultaneousGesture(TapGesture().onEnded {
                    showError = !isValid
                })
                .disabled(!isValid)
                .opacity(isValid ? 1 : 0.6)

                Button { } label: {
                    Text("Forgot password?")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }

                Spacer()
            }
            .padding()
        }
        .navigationTitle("Log In")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var isValid: Bool {
        email.contains("@") && password.count >= 6
    }
}

// Home screen

struct HomeView: View {
    @State private var showComposer = false

    var body: some View {
        ZStack {
            LinearGradient(colors: [.indigo.opacity(0.2), .cyan.opacity(0.2)],
                           startPoint: .topLeading, endPoint: .bottomTrailing)
            .ignoresSafeArea()

            VStack(spacing: 20) {
                Text("Home")
                    .font(.largeTitle.bold())

                Text("You’re logged in. Swipe right from the left edge to go back, or start a note.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                Button { showComposer = true } label: {
                    SpriteButtonLabel(text: "New Note", systemImage: "square.and.pencil")
                }
            }
            .sheet(isPresented: $showComposer) {
                NoteComposer()
            }
        }
    }
}

// Note composer modal

struct NoteComposer: View {
    @Environment(\.dismiss) private var dismiss
    @State private var text = ""

    var body: some View {
        NavigationStack {
            VStack {
                TextEditor(text: $text)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 14).fill(.thinMaterial))
                    .padding()
                Spacer()
            }
            .navigationTitle("New Note")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") { dismiss() }.bold()
                }
            }
        }
    }
}

// Entry point for preview/demo

struct ContentView: View {
    var body: some View {
        NavigationStack {
            TitleScreen()
        }
    }
}

#Preview {
    ContentView()
}
