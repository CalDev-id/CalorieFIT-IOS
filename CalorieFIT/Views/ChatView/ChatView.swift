//
//  ChatView.swift
//  CalorieFIT
//
//  Created by Heical Chandra on 26/04/25.
//
import SwiftUI

struct ChatView: View {
    @StateObject private var viewModel = ChatViewModel()
    @State private var userInput: String = ""

    var body: some View {
        VStack {
            ChatHeaderView()

            ChatMessagesView(viewModel: viewModel)

            ChatInputView(userInput: $userInput, viewModel: viewModel)
                .background(Color.white)

            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }
        }
        .background(.thinMaterial)
        .navigationBarBackButtonHidden(true)
    }
}

// MARK: - Subviews

struct ChatHeaderView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        HStack {
            Image(systemName: "chevron.left")
                .font(.title2)
                .padding(.leading, 24)
                .foregroundColor(.black)
                .onTapGesture {
                    dismiss()
                }
            Spacer()
            Image("calorify_logo")
                .resizable()
                .frame(width: 42, height: 42)
                .cornerRadius(100)
            Text("Calorify")
                .font(.system(size: 15))
                .fontWeight(.semibold)
                .foregroundColor(.black)
            Spacer()
            Image(systemName: "waveform")
                .font(.title2)
                .padding(.trailing, 24)
                .foregroundColor(.black)
        }
        .padding(.vertical, 10)
        .background(Color.white)
    }
}

struct ChatMessagesView: View {
    @ObservedObject var viewModel: ChatViewModel

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(viewModel.chatHistory) { message in
                        HStack {
                            if message.role == "user" {
                                Spacer()
                                Text(message.content)
                                    .padding()
                                    .background(Color.colorGreenPrimary)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                                VStack {
                                    Image("profile")
                                        .resizable()
                                        .frame(width: 38, height: 38)
                                        
                                    Spacer(minLength: 0)
                                }
                            } else {
                                VStack {
                                    Image("calorify_logo")
                                        .resizable()
                                        .frame(width: 38, height: 38)
                                        .cornerRadius(100)
                                    Spacer(minLength: 0)
                                }
                                Text(message.content)
                                    .padding()
                                    .background(Color.gray.opacity(0.1))
                                    .foregroundColor(.black)
                                    .cornerRadius(10)
                                Spacer()
                            }
                        }
                        .id(message.id)
                    }

                    if viewModel.isLoading {
                        HStack {
                            DotLoadingView()
                                .padding()
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(10)
                            Spacer()
                        }
                        .id(UUID())
                    }
                }
                .onChange(of: viewModel.chatHistory.count) { _ in
                    scrollToBottom(proxy: proxy)
                }
                .onChange(of: viewModel.isLoading) { _ in
                    scrollToBottom(proxy: proxy)
                }
                .onAppear {
                    if let lastMessageId = viewModel.chatHistory.last?.id {
                        withAnimation {
                            proxy.scrollTo(lastMessageId, anchor: .bottom)
                        }
                    }
                }
            }
            .scrollIndicators(.hidden)
            .padding(.horizontal, 14)
        }
    }

    private func scrollToBottom(proxy: ScrollViewProxy) {
        DispatchQueue.main.async {
            if let lastMessageId = viewModel.chatHistory.last?.id {
                withAnimation {
                    proxy.scrollTo(lastMessageId, anchor: .bottom)
                }
            }
        }
    }
}

struct ChatInputView: View {
    @Binding var userInput: String
    @ObservedObject var viewModel: ChatViewModel

    var body: some View {
        ZStack {
            ZStack(alignment: .leading) {
//                if userInput.isEmpty {
//                    Text("Message Keqing")
//                        .foregroundColor(.white)
//                        .padding(.leading, 16)
//                }

                TextField("Type Here..", text: $userInput)
                    .padding(14)
                    .padding(.trailing, 40)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                    .foregroundColor(.black)
                    .textFieldStyle(PlainTextFieldStyle())
            }

            HStack {
                Spacer()
                Button(action: sendMessage) {
                    Image(systemName: "paperplane.fill")
                        .font(.title)
                        .foregroundColor(.colorGreenPrimary)
                }
                .background(Color.gray.opacity(0.0))
                .padding(.trailing, 10)
            }
        }
        .background(Color.white)
        .padding(14)
    }

    private func sendMessage() {
        viewModel.addUserMessage(userInput)
        userInput = ""
        viewModel.sendMessage()
    }
}
