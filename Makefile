all: clean gen
  
gen:
	 sh build.sh TestUtils TestUtils-Package
clean: 
	rm -rf TestUtils.xcframework
