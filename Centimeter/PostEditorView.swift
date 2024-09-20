//
//  PostView.swift
//  Centimeter
//
//  Created by 김동현 on 9/20/24.
//

import SwiftUI

struct PostEditorView: View {
    @Binding var posts: [Post]
    @State private var title: String = ""
    @State private var content: String = ""
    @Environment(\.dismiss) private var dismiss
    var editingPost: Post?
    @State private var selectedColor: Color = .white
    
    var body: some View {
        VStack {
            // MARK: - 색상 선택 버튼
            HStack {
                let colors: [Color] = [.red, .green, .blue, .yellow, .orange, .white]
                
                ForEach(colors, id: \.self) { color in
                    Circle()
                        .fill(color)
                        .frame(width: 30, height: 30)
                        .onTapGesture {
                            selectedColor = color
                            print("선택한 색상: \(selectedColor.toHex())")
                        }
                        .overlay {
                            Circle()
                                .stroke(selectedColor == color ? Color.black : Color.clear, lineWidth: 2)
                        }
                }
            }
            
            

            
            TextField("제목", text: $title)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            TextEditor(text: $content)
                .border(Color.gray, width: 1)
                .padding()
                .frame(minHeight: 200)
            
            
            Button("저장") {
                
                let postColor = selectedColor.toHex()// 선택한 색상으로 배경 설정
                print("저장할 색상: \(postColor)")

                if let editingPost = editingPost {
                    // 기존 게시글 수정
                    if let index = posts.firstIndex(where: {$0.id == editingPost.id}) {
                        posts[index] = Post(title: title, content: content, date: formattedDate(), color: postColor)
                    }
                } else {
                    let newPost = Post(title: title, content: content, date: formattedDate(), color: postColor)
                    posts.append(newPost) // 게시글 추가
                    print("새 게시글 추가: \(newPost)") // 로그 추가
                }
                    
                
                
                
                // 여기를 누르면 돌아가기
                dismiss()
            }
            .padding()
            .background(.black)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .padding()
        // .navigationTitle("게시글 작성")
        .navigationTitle(editingPost == nil ? "게시글 작성" : "게시글 수정")
        .onAppear {
            if let editingPost = editingPost {
                title = editingPost.title
                content = editingPost.content
            }
        }
    }
    
    private func formattedDate() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.dateFormat = "yyyy년 MM월 dd일"
        return formatter.string(from: Date())
    }
}


#Preview {
    let samplePosts: [Post] = []
    return PostEditorView(posts: .constant(samplePosts))
}



struct Post: Identifiable, Codable, Equatable {
    var id = UUID()
    let title: String
    let content: String
    let date: String
    let color: String
}


extension Color {
    func toHex() -> String {
           let uiColor = UIColor(self) // Color를 UIColor로 변환
           guard let components = uiColor.cgColor.components, components.count >= 3 else {
               return "#000000" // 기본값
           }
           
           let r = Int(components[0] * 255)
           let g = Int(components[1] * 255)
           let b = Int(components[2] * 255)
           return String(format: "#%02X%02X%02X", r, g, b)
       }

    init?(hex: String) {
            var rgb: UInt64 = 0
            var hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines)
            if hexString.hasPrefix("#") {
                hexString.remove(at: hexString.startIndex)
            }
            
            // 6자리 hex인지 확인
            guard hexString.count == 6, Scanner(string: hexString).scanHexInt64(&rgb) else {
                print("잘못된 HEX 값: \(hex)") // 디버깅 로그
                return nil
            }

            let r = Double((rgb >> 16) & 0xFF) / 255
            let g = Double((rgb >> 8) & 0xFF) / 255
            let b = Double(rgb & 0xFF) / 255
            self.init(red: r, green: g, blue: b)
        }
}
