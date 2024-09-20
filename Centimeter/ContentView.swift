//
//  ContentView.swift
//  Centimeter
//
//  Created by 김동현 on 9/20/24.
//

import SwiftUI

struct ContentView: View {
    // MARK: - 게시글 배열 상태 관리
    @State private var posts: [Post] = []
    
    // MARK: - 로컬 저장 변수
    private let userDefaultsHelper = UserDefaultsHelper()
    
    var body: some View {
        VStack {
            // MARK: - @Binding으로 posts전달
            CMSearchView(posts: $posts)
                .ignoresSafeArea()
        }
        //.padding(.top)
        .padding(.leading)
        .padding(.trailing)
        .onAppear {
            // 앱 시작시 게시글 로드
            posts = userDefaultsHelper.loadPosts()
        }
        .onChange(of: posts) { newPosts in
            // 게시글 변경 시 저장
            userDefaultsHelper.savePosts(newPosts)
        }
    }
}

#Preview {
    ContentView()
}

// MARK: - 검색창, 테이블뷰
struct CMSearchView: View {
    // MARK: - 부모 뷰에서 전달받은 게시글 배열
    @Binding var posts: [Post]
    @State private var searchText: String = ""
    //let names = ["제목1", "제목2", "제목3", "제목4", "제목5"]
    
    var filteredPosts: [Post] {
        if searchText.isEmpty {
            return posts
        } else {
            return posts.filter{ $0.title.localizedCaseInsensitiveContains(searchText)}
        }
    }
    
    private func deletePost(_ post: Post) {
        if let index = posts.firstIndex(where: {$0.id == post.id}) {
            posts.remove(at: index)
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                
                VStack {
                    
                    // 메모
                    Text("메모")
                        .font(.largeTitle)
                        .bold()
                    //.padding(.top)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading)
                    
                    // MARK: - 설정창
                    .navigationBarItems(trailing:
                        NavigationLink(destination: SettingsView()) {
                            Image(systemName: "gearshape")
                                .font(.system(size: 20)) // 원하는 크기로 조정
                                .foregroundColor(.black)
                        }
                    )
                    
                    // 항상 고정된 검색창
                    SearchBar(text: $searchText)
                    //.padding(.top)
                    
                    Spacer(minLength: 20)
                    
                    ScrollView {
                        Spacer(minLength: 10)
                        LazyVStack(spacing: 20) {
                            ForEach(filteredPosts.reversed()) { post in
                                NavigationLink(destination: PostEditorView(posts: $posts, editingPost: post)) {
                                    MemoItemView(title: post.title, content: post.content, date: post.date, color: post.color)
                                    
                                }
                                .contextMenu {
                                    Button(action: {
                                        deletePost(post)
                                    }) {
                                        Text("삭제")
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    //.navigationTitle("메모")
                }

                VStack {
                    Spacer()
                    
                    HStack {
                        //Spacer()
                        
                        // MARK: - 버튼
                        NavigationLink(destination: PostEditorView(posts: $posts)) {
                            Text("글작성")
                                .padding()
                                .background(.black)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                .padding()
                        }
                    }
                }
            }
        }
    }
}



// MARK: - 검색창
struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        TextField("검색", text: $text)
            .padding(10)
            .background(Color(.systemGray6))
            .cornerRadius(8)
            .padding(.horizontal)
    }
}

// MARK: - 커스텀 메모화면
struct MemoItemView: View {
    let title: String
    let content: String
    let date: String
    let color: String
    
    func print() {
        Swift.print("디버깅: \(self.color)")
    }
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)            // 크고 두드러지게 표시
                .foregroundColor(.black)
                .padding()                  // 텍스트 주위에 여백을 추가

            
            Text(comtentPreview(content))
                .foregroundColor(.black)
                .padding()
                //.frame(maxWidth: .infinity, alignment: .leading)
                
            HStack {
                Spacer()
                Text(date)
                    .foregroundColor(.black)
                    .padding()
            }
            
        }
        //.frame(maxWidth: .infinity, alignment: .leading)
        .frame(minHeight: 150)
        .background(Color(hex: color) ?? Color.white)
        .cornerRadius(10)
        
        
        // 테두리 색상과 두께 설정
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.gray, lineWidth: 1)
        )
        
        .shadow(color: .gray.opacity(0.7), radius: 3, x: 1, y: 1)
        .contentShape(Rectangle())      // 모양과 관계없이 클릭가능영역확대
        .buttonStyle(PlainButtonStyle())// 기본적인 버튼 스타일 제거
        .onAppear {
                    print() // 색상 확인을 위해 호출
                }
    }
    
    // conetnt 10자 초과시 미리보기로 10자만 출력
    private func comtentPreview(_ content: String) -> String {
        if content.count > 30 {
            let prefixText = content.prefix(30)
            return "\(prefixText)"
        } else {
            return content
        }
    }
}
