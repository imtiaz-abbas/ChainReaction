task :default => "build"

desc "Install Pod dependencies"
task :install_deps do
 sh "pod install"
end
desc "Clean up derived data and pods"
task :clean do
  sh "rm -rf ~/Library/Developer/Xcode/DerivedData/ChainReaction*"
  sh "rm -rf Pods"
end
desc "Synchronize xcode groups & folders"
task :synx do
  sh "synx ./ChainReaction.xcodeproj"
end
desc "Build project workspace"
task :build => ["clean", "synx", "install_deps"] do
end
desc "Lint and Auto Correct"
task :lint do
  sh "Pods/SwiftLint/swiftlint autocorrect"
end