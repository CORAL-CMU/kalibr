cmake_minimum_required(VERSION 2.8.3)
project(sm_random)

find_package(catkin REQUIRED)
include_directories(${catkin_INCLUDE_DIRS})

find_package(Boost 1.58.0 EXACT REQUIRED COMPONENTS system)
include_directories(${Boost_INCLUDE_DIRS})

catkin_package(
  INCLUDE_DIRS include
  LIBRARIES ${PROJECT_NAME}
  CATKIN_DEPENDS 
  DEPENDS
)

include_directories(include)

##############
## Building ##
##############

add_library(${PROJECT_NAME}
  src/random.cpp
)

##################
## Installation ##
##################

install(TARGETS ${PROJECT_NAME}
  ARCHIVE DESTINATION ${CATKIN_PACKAGE_LIB_DESTINATION}
  LIBRARY DESTINATION ${CATKIN_PACKAGE_LIB_DESTINATION}
  RUNTIME DESTINATION ${CATKIN_PACKAGE_BIN_DESTINATION}
)

## Mark cpp header files for installation
install(DIRECTORY include/${PROJECT_NAME}/
  DESTINATION ${CATKIN_PACKAGE_INCLUDE_DESTINATION}
  FILES_MATCHING PATTERN "*.hpp"
  PATTERN ".svn" EXCLUDE
)