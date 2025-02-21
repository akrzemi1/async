#
# Copyright (c) 2022 Klemens Morgenstern (klemens.morgenstern@gmx.net)
#
# Distributed under the Boost Software License, Version 1.0. (See accompanying
# file LICENSE_1_0.txt or copy at http://www.boost.org/LICENSE_1_0.txt)
#

deps = [
    'libs/array',
    'libs/align',
    'libs/asio',
    'libs/assert',
    'libs/beast',
    'libs/bind',
    'libs/chrono',
    'libs/circular_buffer',
    'libs/concept_check',
    'libs/config',
    'libs/container',
    'libs/core',
    'libs/date_time',
    'libs/headers',
    'libs/integer',
    'libs/intrusive',
    'libs/leaf',
    'libs/mpl',
    'libs/move',
    'libs/mp11',
    'libs/numeric',
    'libs/predef',
    'libs/preprocessor',
    'libs/ratio',
    'libs/system',
    'libs/static_assert',
    'libs/smart_ptr',
    'libs/test',
    'libs/thread',
    'libs/throw_exception',
    'libs/utility',
    'libs/type_traits',
    'libs/variant2',
    'libs/winapi',
    'tools/build',
    'tools/boost_install',
    'tools/boostdep'
    ]


def git_boost_steps(branch, image="alpine/git", env_win_style=False):
    return [{
            "name": "boost ({})".format(branch),
            "image": image,
            "commands": [
               "git clone -b {} --depth 1 https://github.com/boostorg/boost.git boost".format(branch)
                ]
        },
        {
            "name": "boost submodules",
            "image": image,
            "commands": [
                "cd boost",
                "git submodule update --init --depth 20 --jobs 8 " + " ".join(deps)
            ]
        },
        {
            "name": "clone",
            "image": image,
            "commands": [
                "cd boost/libs",
                "git clone {}".format("$Env:DRONE_REMOTE_URL" if env_win_style else "$DRONE_REMOTE_URL"),
                "cd async",
                "git checkout {}".format("$Env:DRONE_COMMIT" if env_win_style else "$DRONE_COMMIT")
            ]
        }
    ]


def format_b2_args(**kwargs):
    res = ""
    for k in kwargs:
        res += " {}={}".format(k.replace('_', '-'), kwargs[k])
    return res


def linux_build_steps(image, **kwargs):
    args = format_b2_args(**kwargs)
    return [
        {
            "name": "bootstrap",
            "image": image,
            "commands": [
                "cd boost",
                "./bootstrap.sh"
            ]
        },
        {
            "name": "build",
            "image": image,
            "commands" : [
                "cd boost/libs/async",
                "../../b2 build -j8 " + args
            ]
        },
        {
            "name": "test",
            "image": image,
            "commands" : [
                "cd boost/libs/async",
                "../../b2 test -j8 " + args
            ]
        }
    ]


def windows_build_steps(image, **kwargs):
    args = format_b2_args(**kwargs)
    return [
        {
            "name": "bootstrap",
            "image": image,
            "commands": [
                "cd boost",
                ".\\\\bootstrap.bat"
            ]
        },
        {
            "name" : "build",
            "image" : image,
            "commands": [
                "cd boost/libs/async",
                "..\\\\..\\\\b2 build -j8 " + args
            ]
        },
        {
            "name": "test",
            "image": image,
            "commands": [
                "cd boost/libs/async",
                "..\\\\..\\\\b2 test -j8 " + args
            ]
        }
    ]


def linux(
        name,
        branch,
        image,
        **kwargs):

    return {
        "kind": "pipeline",
        "type": "docker",
        "name": name,
        "clone": {"disable": True},
        "platform": {
            "os": "linux",
            "arch": "amd64"
        },
        "steps": git_boost_steps(branch) + linux_build_steps(image, **kwargs)
    }


def windows(
        name,
        branch,
        image,
        **kwargs):

    return {
        "kind": "pipeline",
        "type": "docker",
        "name": name,
        "clone": {"disable": True},
        "platform": {
            "os": "windows",
            "arch": "amd64"
        },
        "steps": git_boost_steps(branch, image, True) + windows_build_steps(image, **kwargs)
    }


def main(ctx):
    branch = ctx.build.branch
    if ctx.build.event == 'tag' or (branch != 'master' and branch != 'refs/heads/master'):
        branch = 'develop'

    return [
        linux("gcc-12",                 branch, "docker.io/library/gcc:12",  variant="release", cxxstd="20"),
        linux("gcc-12 (io_context)",    branch, "docker.io/library/gcc:12",  variant="release", cxxstd="20", **{'boost.async.executor': 'use_io_context'}),
        linux("gcc-12 (container.pmr)", branch, "docker.io/library/gcc:12",  variant="release", cxxstd="20", **{'boost.async.pmr': 'boost-container'}),
        linux("gcc-12 (no pmr)",        branch, "docker.io/library/gcc:12",  variant="release", cxxstd="20", **{'boost.async.pmr': 'no'}),
        linux("clang",                  branch, "docker.io/silkeh/clang", toolset='clang', variant="release", cxxstd="20"),
        linux("clang (container.pmr)",  branch, "docker.io/silkeh/clang", toolset='clang', variant="release", cxxstd="20", **{'boost.async.pmr': 'boost-container'}),
        linux("clang (no pmr)",         branch, "docker.io/silkeh/clang", toolset='clang', variant="release", cxxstd="20", **{'boost.async.pmr': 'no'}),
        linux("clang (asan)",           branch, "docker.io/silkeh/clang", toolset='clang', variant="release", cxxstd="20", debug_symbols="on", address_sanitizer="on"),
        linux("clang (tsan)",           branch, "docker.io/silkeh/clang", toolset='clang', variant="release", cxxstd="20", debug_symbols="on",  thread_sanitizer="on"),
        windows("msvc-14.3 (x64)",      branch, "cppalliance/dronevs2022:latest", variant="release", cxxstd="20", address_model="64"),
        windows("msvc-14.3 (x32)",      branch, "cppalliance/dronevs2022:latest", variant="release", cxxstd="20", address_model="32")
    ]
