if(HAVE_BREAKPAD)
  set(FIND_BREAKPAD_QUIET 1)
endif(HAVE_BREAKPAD)

if(HAVE_DUMP_SYMBOLS)
  set(FIND_DUMP_SYMBOLS_QUIET 1)
endif(HAVE_DUMP_SYMBOLS)

OPTION(ENABLE_DUMP_SYMBOLS "Create breakpad symbols" ON)




set(DO_DUMP_SYMBOLS 0)
find_program(DUMP_SYMS dump_syms HINTS ${dependdir}/bin ${BREAKPAD_PATH}/bin ${HOST_BREAKPAD_HOME}/bin)
if(DUMP_SYMS MATCHES "-NOTFOUND")
  message(STATUS "dump_syms not found, will not create breakpad symbols")
else(DUMP_SYMS MATCHES "-NOTFOUND")
  if(NOT FIND_DUMP_SYMBOLS_QUIET)
    message(STATUS "dump_syms found ${DUMP_SYMS}")
  endif(NOT FIND_DUMP_SYMBOLS_QUIET)
  if(ENABLE_DUMP_SYMBOLS)
    set(DO_DUMP_SYMBOLS 1)
  endif(ENABLE_DUMP_SYMBOLS)
endif(DUMP_SYMS MATCHES "-NOTFOUND")

set(HAVE_BREAKPAD 0)

if(APPLE)
  set(PLAT "mac")
elseif(UNIX)
  set(PLAT "linux")
else(APPLE)
  set(PLAT "windows")
endif(APPLE)


message(STATUS "Looking in ${IMAGE_BREAKPAD_HOME}")
find_path(BREAKPAD_INCLUDES exception_handler.h PATH ${dependdir}/include/breakpad ${BREAKPAD_PATH}/include ${IMAGE_BREAKPAD_HOME}/include/ PATH_SUFFIXES client/${PLAT}/handler )
if(BREAKPAD_INCLUDES MATCHES "-NOTFOUND")
  message(STATUS "Can't find exception_handler.h")
else(BREAKPAD_INCLUDES MATCHES "-NOTFOUND")
  STRING(REPLACE "/client/${PLAT}/handler" "" BREAKPAD_INC_DIR ${BREAKPAD_INCLUDES})
  find_library(LIBBREAKPAD_CLIENT NAMES breakpad_client PATHS ${dependdir}/lib ${BREAKPAD_PATH}/lib ${IMAGE_BREAKPAD_HOME}/lib )
  set(LIBBREAKPAD_CLIENT ${IMAGE_BREAKPAD_HOME}/lib/libbreakpad_client.a)
  if(LIBBREAKPAD_CLIENT MATCHES "-NOTFOUND")
    message(STATUS "No breakpad support")
  else(LIBBREAKPAD_CLIENT MATCHES "-NOTFOUND")
    if(NOT FIND_BREAKPAD_QUIET)
      message(STATUS "Found breakpad_client ${LIBBREAKPAD_CLIENT}")
    endif(NOT FIND_BREAKPAD_QUIET)
    set(HAVE_BREAKPAD 1)
  endif(LIBBREAKPAD_CLIENT MATCHES "-NOTFOUND")
endif(BREAKPAD_INCLUDES MATCHES "-NOTFOUND")
