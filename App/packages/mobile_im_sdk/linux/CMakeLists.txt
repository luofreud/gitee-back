cmake_minimum_required(VERSION 3.13)
project(mobile_im_sdk_library VERSION 1.0.0 LANGUAGES C)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_AUTOMOC ON)

set(PLUGIN_NAME "mobile_im_sdk_plugin")

add_library(${PLUGIN_NAME} SHARED
  "mobile_im_sdk_plugin.cc"
)

target_include_directories(${PLUGIN_NAME} PUBLIC
  "${CMAKE_CURRENT_SOURCE_DIR}/include"
)

target_link_libraries(${PLUGIN_NAME} PRIVATE flutter_linux_plugin)

set(PLUGIN_BUNDLED_LIBRARIES)

# flutter_epilogue 由 Flutter 构建系统注入
