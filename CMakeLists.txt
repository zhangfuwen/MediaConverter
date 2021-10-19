cmake_minimum_required(VERSION 3.12.2)

project (addnum)

add_library(addnum STATIC src/add_num.cpp)
target_include_directories( addnum 
    PUBLIC
        "${CMAKE_CURRENT_SOURCE_DIR}/include"
)

add_executable(addnumapp src/main.cpp)
target_link_libraries(addnumapp addnum)

install(TARGETS addnumapp
    COMPONENT linapp
    RUNTIME DESTINATION "/usr/local/bin/"
    LIBRARY DESTINATION "/usr/local/lib/"
)

SET(CPACK_GENERATOR "DEB")
SET(CPACK_DEBIAN_PACKAGE_MAINTAINER "Dean") #required
set(CPACK_PACKAGE_NAME "media-converter") # debian package name
set(CPACK_PACKAGE_VERSION "1.1")
set(CPACK_DEBIAN_PACKAGE_CONTROL_EXTRA, ./script/prerm)
set(CPACK_DEBIAN_PACKAGE_DEPENDS "libc6 (>= 2.34), ffmpeg (>= 7:4.4-6ubuntu5), zenity (>= 3.32.0-7build1)" )

INSTALL(FILES media-converter.desktop DESTINATION share/applications PERMISSIONS OWNER_READ OWNER_WRITE WORLD_READ WORLD_EXECUTE)
INSTALL(FILES media-converter.sh DESTINATION /usr/local/bin/ PERMISSIONS OWNER_READ OWNER_WRITE WORLD_READ WORLD_EXECUTE)
INSTALL(FILES media-converter.png DESTINATION share/icons/hicolor/scalable/apps/ PERMISSIONS OWNER_READ OWNER_WRITE WORLD_READ WORLD_EXECUTE)
INCLUDE(CPack)
