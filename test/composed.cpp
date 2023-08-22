//
// Copyright (c) 2023 Klemens Morgenstern (klemens.morgenstern@gmx.net)
//
// Distributed under the Boost Software License, Version 1.0. (See accompanying
// file LICENSE_1_0.txt or copy at http://www.boost.org/LICENSE_1_0.txt)
//

#include <boost/async/composed.hpp>
#include <boost/async/op.hpp>

#include "doctest.h"
#include "test.hpp"

using namespace boost;


TEST_SUITE_BEGIN("composed");

struct post_op : async::op<>
{
  asio::any_io_executor exec;

  post_op(asio::any_io_executor exec) : exec(exec) {}

  void initiate(async::completion_handler<> complete)
  {
    co_await asio::post(async::use_op);
  }
};


struct ec_op : async::op<system::error_code>
{
  asio::any_io_executor exec;

  ec_op(asio::any_io_executor exec) : exec(exec) {}

  void initiate(async::completion_handler<system::error_code> complete)
  {
    co_return asio::error::already_open;
  }
};

struct ec_n_op : async::op<system::error_code, std::size_t>
{
  asio::any_io_executor exec;

  ec_n_op(asio::any_io_executor exec) : exec(exec) {}

  void initiate(async::completion_handler<system::error_code, std::size_t> complete)
  {
    co_await asio::post(async::use_op);
    co_return {{}, 2u};
  }
};


CO_TEST_CASE("composed-op")
{
  co_await post_op(co_await async::this_coro::executor);
  CHECK_THROWS(co_await ec_op(co_await async::this_coro::executor), system::system_error(asio::error::already_open));
  CHECK(co_await ec_n_op(co_await async::this_coro::executor) == 2u);
}

TEST_SUITE_END();