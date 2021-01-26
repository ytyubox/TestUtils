all: clean gen
  
xcode:
	swift package generate-xcodeproj
gen:
	 sh build.sh TestUtils TestUtils-Package
clean: 
	rm -rf TestUtils.xcframework
