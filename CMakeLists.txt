cmake_minimum_required(VERSION 3.16)

project(eyerelax VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Quick)

qt_standard_project_setup()

set(SOURCES main.cpp)

set(DATA_FILE README.md)

list (APPEND RESOURCES img.qrc qml.qrc)
qt_add_resources(SOURCES ${RESOURCES})

qt_add_executable(appeyerelax
    ${SOURCES}
    ${DATA_FILE}
)

qt_add_qml_module(appeyerelax
    URI eyerelax
    VERSION 1.0
    QML_FILES
        main.qml
)


# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(appeyerelax PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appeyerelax
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appeyerelax
    PRIVATE Qt6::Quick
)

include(GNUInstallDirs)
install(TARGETS appeyerelax
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
