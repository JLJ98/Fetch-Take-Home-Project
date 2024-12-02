//
//  RecipeDetailView.swift
//  FetchRecipesApp
//
//  Created by Jon-Luke Jenkins on 11/30/24.
//
import SwiftUI


struct RecipeDetailView: View {
    let recipe: Recipe
    @State private var showAlert = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Recipe image
                if let photoURL = recipe.photoURLLarge, let url = URL(string: photoURL) {
                    AsyncImage(url: url) { image in
                        image.resizable()
                            .aspectRatio(contentMode: .fit)
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(maxWidth: .infinity)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                }

                // Recipe name
                Text(recipe.name)
                    .font(.largeTitle)
                    .fontWeight(.bold)

                // Recipe cuisine
                Text("Cuisine: \(recipe.cuisine)")
                    .font(.title2)
                    .foregroundColor(.gray)

                // Source link
                if let sourceURL = recipe.sourceURL, let url = URL(string: sourceURL) {
                    Link("View Full Recipe", destination: url)
                        .font(.headline)
                        .foregroundColor(.blue)
                } else {
                    Text("Full recipe not available.")
                        .font(.headline)
                        .foregroundColor(.gray)
                }

                // YouTube link button
                if let youtubeURL = recipe.youtubeURL, let url = URL(string: youtubeURL) {
                    Button(action: {
                        if isValidYouTubeURL(youtubeURL) {
                            UIApplication.shared.open(url)
                        } else {
                            showAlert = true
                        }
                    }) {
                        HStack {
                            Image(systemName: "play.circle.fill") // YouTube-style play icon
                                .resizable()
                                .frame(width: 24, height: 24)
                                .foregroundColor(.white) // White play icon
                            Text("Watch on YouTube")
                                .font(.headline)
                                .foregroundColor(.white)
                        }
                        .padding()
                        .background(Color.red) // YouTube red color
                        .cornerRadius(10)
                    }
                    .alert("Video not available", isPresented: $showAlert) {
                        Button("OK", role: .cancel) {}
                    } message: {
                        Text("The YouTube video for this recipe is not available.")
                    }
                } else {
                    Text("YouTube video not available.")
                        .font(.headline)
                        .foregroundColor(.gray)
                }

                // Note about availability
                Text("Note: Some YouTube videos may no longer be available.")
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .padding(.top, 10)
            }
            .padding()
        }
        .navigationTitle(recipe.name)
        .navigationBarTitleDisplayMode(.inline)
    }

    // Function to validate YouTube URLs
    private func isValidYouTubeURL(_ url: String) -> Bool {
        return url.contains("youtube.com/watch") || url.contains("youtu.be")
    }
}

