//
// Copyright (c) 2022 Klemens Morgenstern (klemens.morgenstern@gmx.net)
//
// Distributed under the Boost Software License, Version 1.0. (See accompanying
// file LICENSE_1_0.txt or copy at http://www.boost.org/LICENSE_1_0.txt)
//

#ifndef BOOST_ASYNC_THIS_THREAD_HPP
#define BOOST_ASYNC_THIS_THREAD_HPP

#include <boost/async/config.hpp>
#include <boost/config.hpp>


#include <boost/asio/io_context.hpp>

namespace boost::async::this_thread
{

#if !defined(BOOST_ASYNC_NO_PMR)
BOOST_ASYNC_DECL pmr::memory_resource* get_default_resource() noexcept;
BOOST_ASYNC_DECL pmr::memory_resource* set_default_resource(pmr::memory_resource* r) noexcept;
BOOST_ASYNC_DECL pmr::polymorphic_allocator<void> get_allocator();
#endif

BOOST_ASYNC_DECL
executor & get_executor(
    const boost::source_location & loc = BOOST_CURRENT_LOCATION);
BOOST_ASYNC_DECL bool has_executor();
BOOST_ASYNC_DECL void set_executor(executor exec) noexcept;

}

#endif //BOOST_ASYNC_THIS_THREAD_HPP
