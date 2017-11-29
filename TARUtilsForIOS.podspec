Pod::Spec.new do |s|
s.name = 'TARUtilsForIOS'
s.version = '1.0.1'
s.license = 'MIT'
s.summary = '唐爱荣的工具箱 For iOS.'
s.homepage = 'https://github.com/touaiei/TARUtilsForIOS'
s.authors = { '唐爱荣' => 'touaiei@163.com' }
s.source = { :git => 'https://github.com/touaiei/TARUtilsForIOS.git', :tag => s.version.to_s }
s.requires_arc = true
s.ios.deployment_target = '8.0'
s.source_files = 'TARUtilsForIOS/*.{h,m}'
end

