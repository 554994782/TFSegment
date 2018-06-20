
Pod::Spec.new do |s|

  s.name         = "TFSegment"
  s.version      = "2.0.0"
  s.summary      = "Have no summary TFSegment."

  s.description  = <<-DESC
                   A Main Foundation Component for Other Kit
                   DESC

  s.homepage     = "https://github.com/554994782/TFSegment.git"

  s.license      = "MIT"

  s.author       = { "jiangyunfeng" => "554994782@qq.com" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/554994782/TFSegment.git", :tag => s.version }

  s.source_files  = "TFSegment"

s.subspec "Custom" do |ss|
ss.source_files = "TFSegment/Custom/*.{h,swift,c,m}"
end

s.public_header_files = "TFSegment/**/*.h"

end
