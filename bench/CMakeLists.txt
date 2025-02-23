
add_executable(boost_async_post_bench post.cpp)
target_link_libraries(boost_async_post_bench PRIVATE Boost::async Boost::system Threads::Threads)
if (TARGET Boost::context)
    target_link_libraries(boost_async_post_bench PRIVATE Boost::context)
    target_compile_definitions(boost_async_post_bench PRIVATE BOOST_ASYNC_BENCH_WITH_CONTEXT=1)
    set_property(TARGET boost_async_post_bench PROPERTY INTERPROCEDURAL_OPTIMIZATION ON)
endif()

add_executable(boost_async_immediate_bench immediate.cpp)
target_link_libraries(boost_async_immediate_bench PRIVATE Boost::async Boost::system Threads::Threads)
if (TARGET Boost::context)
    target_link_libraries(boost_async_immediate_bench PRIVATE Boost::context)
    target_compile_definitions(boost_async_immediate_bench PRIVATE BOOST_ASYNC_BENCH_WITH_CONTEXT=1)
    set_property(TARGET boost_async_immediate_bench PROPERTY INTERPROCEDURAL_OPTIMIZATION ON)
endif()

add_executable(boost_async_channel_bench channel.cpp)
target_link_libraries(boost_async_channel_bench PRIVATE Boost::async Boost::system Threads::Threads)
if (TARGET Boost::context)
    target_link_libraries(boost_async_channel_bench PRIVATE Boost::context)
    target_compile_definitions(boost_async_channel_bench PRIVATE BOOST_ASYNC_BENCH_WITH_CONTEXT=1)
    set_property(TARGET boost_async_channel_bench PROPERTY INTERPROCEDURAL_OPTIMIZATION ON)
endif()

add_executable(boost_async_parallel_bench parallel.cpp)
target_link_libraries(boost_async_parallel_bench PRIVATE Boost::async Boost::system Threads::Threads)
if (TARGET Boost::context)
    target_link_libraries(boost_async_parallel_bench PRIVATE Boost::context)
    target_compile_definitions(boost_async_parallel_bench PRIVATE BOOST_ASYNC_BENCH_WITH_CONTEXT=1)
    set_property(TARGET boost_async_parallel_bench PROPERTY INTERPROCEDURAL_OPTIMIZATION ON)
endif()



add_executable(boost_async_monotonic_bench monotonic.cpp)
target_link_libraries(boost_async_monotonic_bench PRIVATE Boost::async Boost::system Threads::Threads)
if (TARGET Boost::context)
    target_link_libraries(boost_async_monotonic_bench PRIVATE Boost::context)
    target_compile_definitions(boost_async_monotonic_bench PRIVATE BOOST_ASYNC_BENCH_WITH_CONTEXT=1)
    set_property(TARGET boost_async_monotonic_bench PROPERTY INTERPROCEDURAL_OPTIMIZATION ON)
endif()
