#!/usr/bin/env luapp5.3

-- Copyright 2019 Cartesi Pte. Ltd.
--
-- This file is part of the machine-emulator. The machine-emulator is free
-- software: you can redistribute it and/or modify it under the terms of the GNU
-- Lesser General Public License as published by the Free Software Foundation,
-- either version 3 of the License, or (at your option) any later version.
--
-- The machine-emulator is distributed in the hope that it will be useful, but
-- WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
-- FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License
-- for more details.
--
-- You should have received a copy of the GNU Lesser General Public License
-- along with the machine-emulator. If not, see http://www.gnu.org/licenses/.
--

local cartesi = require"cartesi"
local util = require"cartesi.util"

-- Tests Cases
-- format {"ram_image_file", number_of_cycles, halt_payload, yield_payloads}
local tests = {
  {"rv64mi-p-access.bin", 110},
  {"rv64mi-p-breakpoint.bin", 61},
  {"rv64mi-p-csr.bin", 173},
  {"rv64mi-p-illegal.bin", 410},
  {"rv64mi-p-ma_addr.bin", 682},
  {"rv64mi-p-ma_fetch.bin", 196},
  {"rv64mi-p-mcsr.bin", 69},
  {"rv64mi-p-sbreak.bin", 74},
  {"rv64mi-p-scall.bin", 63},
  {"rv64si-p-csr.bin", 126},
  {"rv64si-p-dirty.bin", 143},
  {"rv64si-p-ma_fetch.bin", 154},
  {"rv64si-p-sbreak.bin", 69},
  {"rv64si-p-scall.bin", 76},
  {"rv64si-p-wfi.bin", 57},
  {"rv64ua-p-amoadd_d.bin", 74},
  {"rv64ua-p-amoadd_w.bin", 71},
  {"rv64ua-p-amoand_d.bin", 71},
  {"rv64ua-p-amoand_w.bin", 70},
  {"rv64ua-p-amomax_d.bin", 70},
  {"rv64ua-p-amomax_w.bin", 70},
  {"rv64ua-p-amomaxu_d.bin", 70},
  {"rv64ua-p-amomaxu_w.bin", 70},
  {"rv64ua-p-amomin_d.bin", 70},
  {"rv64ua-p-amomin_w.bin", 70},
  {"rv64ua-p-amominu_d.bin", 70},
  {"rv64ua-p-amominu_w.bin", 70},
  {"rv64ua-p-amoor_d.bin", 69},
  {"rv64ua-p-amoor_w.bin", 69},
  {"rv64ua-p-amoswap_d.bin", 71},
  {"rv64ua-p-amoswap_w.bin", 70},
  {"rv64ua-p-amoxor_d.bin", 72},
  {"rv64ua-p-amoxor_w.bin", 74},
  {"rv64ua-p-lrsc.bin", 6246},
  {"rv64ua-v-amoadd_d.bin", 10748},
  {"rv64ua-v-amoadd_w.bin", 10807},
  {"rv64ua-v-amoand_d.bin", 10819},
  {"rv64ua-v-amoand_w.bin", 10818},
  {"rv64ua-v-amomax_d.bin", 10800},
  {"rv64ua-v-amomax_w.bin", 10800},
  {"rv64ua-v-amomaxu_d.bin", 10800},
  {"rv64ua-v-amomaxu_w.bin", 10800},
  {"rv64ua-v-amomin_d.bin", 10800},
  {"rv64ua-v-amomin_w.bin", 10800},
  {"rv64ua-v-amominu_d.bin", 10806},
  {"rv64ua-v-amominu_w.bin", 10806},
  {"rv64ua-v-amoor_d.bin", 10799},
  {"rv64ua-v-amoor_w.bin", 10799},
  {"rv64ua-v-amoswap_d.bin", 10819},
  {"rv64ua-v-amoswap_w.bin", 10818},
  {"rv64ua-v-amoxor_d.bin", 10802},
  {"rv64ua-v-amoxor_w.bin", 10804},
  {"rv64ua-v-lrsc.bin", 16974},
  {"rv64ui-p-add.bin", 475},
  {"rv64ui-p-addi.bin", 250},
  {"rv64ui-p-addiw.bin", 247},
  {"rv64ui-p-addw.bin", 470},
  {"rv64ui-p-and.bin", 550},
  {"rv64ui-p-andi.bin", 221},
  {"rv64ui-p-auipc.bin", 64},
  {"rv64ui-p-beq.bin", 296},
  {"rv64ui-p-bge.bin", 314},
  {"rv64ui-p-bgeu.bin", 404},
  {"rv64ui-p-blt.bin", 296},
  {"rv64ui-p-bltu.bin", 382},
  {"rv64ui-p-bne.bin", 296},
  {"rv64ui-p-fence_i.bin", 299},
  {"rv64ui-p-jal.bin", 60},
  {"rv64ui-p-jalr.bin", 113},
  {"rv64ui-p-lb.bin", 250},
  {"rv64ui-p-lbu.bin", 250},
  {"rv64ui-p-ld.bin", 384},
  {"rv64ui-p-lh.bin", 262},
  {"rv64ui-p-lhu.bin", 269},
  {"rv64ui-p-lui.bin", 70},
  {"rv64ui-p-lw.bin", 272},
  {"rv64ui-p-lwu.bin", 298},
  {"rv64ui-p-or.bin", 583},
  {"rv64ui-p-ori.bin", 214},
  {"rv64ui-p-sb.bin", 435},
  {"rv64ui-p-sh.bin", 488},
  {"rv64ui-p-sw.bin", 495},
  {"rv64ui-p-sd.bin", 607},
  {"rv64ui-p-simple.bin", 46},
  {"rv64ui-p-sll.bin", 545},
  {"rv64ui-p-slli.bin", 275},
  {"rv64ui-p-slliw.bin", 246},
  {"rv64ui-p-sllw.bin", 505},
  {"rv64ui-p-slt.bin", 464},
  {"rv64ui-p-slti.bin", 242},
  {"rv64ui-p-sltiu.bin", 242},
  {"rv64ui-p-sltu.bin", 481},
  {"rv64ui-p-sra.bin", 517},
  {"rv64ui-p-srai.bin", 263},
  {"rv64ui-p-sraiw.bin", 273},
  {"rv64ui-p-sraw.bin", 517},
  {"rv64ui-p-srl.bin", 559},
  {"rv64ui-p-srli.bin", 284},
  {"rv64ui-p-srliw.bin", 255},
  {"rv64ui-p-srlw.bin", 511},
  {"rv64ui-p-sub.bin", 466},
  {"rv64ui-p-subw.bin", 462},
  {"rv64ui-p-xor.bin", 578},
  {"rv64ui-p-xori.bin", 212},
  {"rv64ui-v-add.bin", 6990},
  {"rv64ui-v-addi.bin", 6765},
  {"rv64ui-v-addiw.bin", 6762},
  {"rv64ui-v-addw.bin", 6985},
  {"rv64ui-v-and.bin", 7065},
  {"rv64ui-v-andi.bin", 6736},
  {"rv64ui-v-auipc.bin", 6578},
  {"rv64ui-v-beq.bin", 6811},
  {"rv64ui-v-bge.bin", 6829},
  {"rv64ui-v-bgeu.bin", 6919},
  {"rv64ui-v-blt.bin", 6811},
  {"rv64ui-v-bltu.bin", 6897},
  {"rv64ui-v-bne.bin", 6811},
  {"rv64ui-v-fence_i.bin", 12994},
  {"rv64ui-v-jal.bin", 6575},
  {"rv64ui-v-jalr.bin", 6628},
  {"rv64ui-v-lb.bin", 11468},
  {"rv64ui-v-lbu.bin", 11468},
  {"rv64ui-v-ld.bin", 11602},
  {"rv64ui-v-lh.bin", 11480},
  {"rv64ui-v-lhu.bin", 11487},
  {"rv64ui-v-lui.bin", 6585},
  {"rv64ui-v-lw.bin", 11490},
  {"rv64ui-v-lwu.bin", 11516},
  {"rv64ui-v-or.bin", 7098},
  {"rv64ui-v-ori.bin", 6729},
  {"rv64ui-v-sb.bin", 11165},
  {"rv64ui-v-sd.bin", 11337},
  {"rv64ui-v-sh.bin", 11218},
  {"rv64ui-v-simple.bin", 6561},
  {"rv64ui-v-sll.bin", 7060},
  {"rv64ui-v-slli.bin", 6790},
  {"rv64ui-v-slliw.bin", 6761},
  {"rv64ui-v-sllw.bin", 7020},
  {"rv64ui-v-slt.bin", 6979},
  {"rv64ui-v-slti.bin", 6757},
  {"rv64ui-v-sltiu.bin", 6757},
  {"rv64ui-v-sltu.bin", 6996},
  {"rv64ui-v-sra.bin", 7032},
  {"rv64ui-v-srai.bin", 6778},
  {"rv64ui-v-sraiw.bin", 6788},
  {"rv64ui-v-sraw.bin", 7032},
  {"rv64ui-v-srl.bin", 7074},
  {"rv64ui-v-srli.bin", 6799},
  {"rv64ui-v-srliw.bin", 6770},
  {"rv64ui-v-srlw.bin", 7026},
  {"rv64ui-v-sub.bin", 6981},
  {"rv64ui-v-subw.bin", 6977},
  {"rv64ui-v-sw.bin", 11225},
  {"rv64ui-v-xor.bin", 7093},
  {"rv64ui-v-xori.bin", 6727},
  {"rv64um-p-div.bin", 106},
  {"rv64um-p-divu.bin", 112},
  {"rv64um-p-divuw.bin", 104},
  {"rv64um-p-divw.bin", 101},
  {"rv64um-p-mul.bin", 465},
  {"rv64um-p-mulh.bin", 473},
  {"rv64um-p-mulhsu.bin", 473},
  {"rv64um-p-mulhu.bin", 505},
  {"rv64um-p-mulw.bin", 404},
  {"rv64um-p-rem.bin", 105},
  {"rv64um-p-remu.bin", 106},
  {"rv64um-p-remuw.bin", 101},
  {"rv64um-p-remw.bin", 107},
  {"rv64um-v-div.bin", 6621},
  {"rv64um-v-divu.bin", 6627},
  {"rv64um-v-divuw.bin", 6619},
  {"rv64um-v-divw.bin", 6616},
  {"rv64um-v-mul.bin", 6980},
  {"rv64um-v-mulh.bin", 6988},
  {"rv64um-v-mulhsu.bin", 6988},
  {"rv64um-v-mulhu.bin", 7020},
  {"rv64um-v-mulw.bin", 6919},
  {"rv64um-v-rem.bin", 6620},
  {"rv64um-v-remu.bin", 6559},
  {"rv64um-v-remuw.bin", 6616},
  {"rv64um-v-remw.bin", 6622},
-- regression tests
  {"sd_pma_overflow.bin", 16},
  {"xpie_exceptions.bin", 51},
  {"htif_devices.bin", 498, 42, {10, 20, 30, 45, 55, 65}}
}

-- Print help and exit
local function help()
    io.stderr:write(string.format([=[
Usage:

  %s [options] <command>

where options are:

  --test-path=<dir>
    path to test binaries
    (default: "./")

  --test=<pattern>
    select tests to run based on a Lua string <pattern>
    (default: ".*", i.e., all tests)

  --periodic-action=<number-period>[,<number-start>]
    stop execution every <number> of cycles and perform action. If
    <number-start> is given, the periodic action will start at that
    mcycle. Only take effect with hash and step commands.
    (default: none)

  --server=<server-address>
    run tests on a remote cartesi machine server. <server-address>
    should be in one of the following formats:
        <host>:<port>
        unix:<path>


and command can be:

  run
    run test and report if payload and cycles match expected

  hash
    output root hash at every <number> of cycles

  step
    output json log of step at every <number> of cycles

  list
    list tests selected by the test <pattern>

  machine
    prints a command for running the test machine

<number> can be specified in decimal (e.g., 16) or hexadeximal (e.g., 0x10),
with a suffix multiplier (i.e., Ki, Mi, Gi for 2^10, 2^20, 2^30, respectively),
or a left shift (e.g., 2 << 20).

]=], arg[0]))
    os.exit()
end

local test_path = "./"
local test_pattern = ".*"
local server_address = nil
local server = nil
local periodic_action = false
local periodic_action_period = math.maxinteger
local periodic_action_start = 0
local cleanup = {}

local function parse_number(n)
    if not n then return nil end
    local base, rest = string.match(n, "^%s*(0x%x+)%s*(.-)%s*$")
    if not base then
        base, rest = string.match(n, "^%s*(%d+)%s*(.-)%s*$")
    end
    base = tonumber(base)
    if not base then return nil end
    if rest == "Ki" then return base << 10
    elseif rest == "Mi" then return base << 20
    elseif rest == "Gi" then return base << 30
    elseif rest == "" then return base end
    local shift = string.match(rest, "^%s*%<%<%s*(%d+)$")
    if shift then
        shift = tonumber(shift)
        if shift then return base << shift end
    end
    return nil
end

-- List of supported options
-- Options are processed in order
-- For each option,
--   first entry is the pattern to match
--   second entry is a callback
--     if callback returns true, the option is accepted.
--     if callback returns false, the option is rejected.
local options = {
    { "^%-%-h$", function(all)
        if not all then return false end
        help()
    end },
    { "^%-%-help$", function(all)
        if not all then return false end
        help()
    end },
    { "^%-%-server%=(.*)$", function(o)
        if not o or #o < 1 then return false end
        server_address = o
        return true
    end },
    { "^%-%-test%-path%=(.*)$", function(o)
        if not o or #o < 1 then return false end
        test_path = o
        return true
    end },
    { "^%-%-test%=(.*)$", function(o, a)
        if not o or #o < 1 then return false end
        test_pattern = o
        return true
    end },
    { "^(%-%-periodic%-action%=(.*))$", function(all, v)
        if not v then return false end
        string.gsub(v, "^([^%,]+),(.+)$", function(p, s)
            periodic_action_period = assert(parse_number(p), "invalid period " .. all)
            periodic_action_start = assert(parse_number(s), "invalid start " .. all)
        end)
        if periodic_action_period == math.maxinteger then
            periodic_action_period = assert(parse_number(v), "invalid period " .. all)
            periodic_action_start = 0
        end
        assert(periodic_action_period > 0, "invalid period " ..
            periodic_action_period)
        periodic_action = true
        return true
    end },
    { ".*", function(all)
        error("unrecognized option " .. all)
    end }
}

local values = {}

-- Process command line options
for i, argument in ipairs({...}) do
    if argument:sub(1,1) == "-" then
        for j, option in ipairs(options) do
            if option[2](argument:match(option[1])) then
                break
            end
        end
    else
        values[#values+1] = argument
    end
end

local command = assert(values[1], "missing command")
assert(test_path, "missing test path")

if server_address then cartesi.grpc = require("cartesi.grpc") end

local function nothing()
end

local function get_next_action_mcycle(cycles)
    if periodic_action then
      local next_action_mcycle = periodic_action_start
      if next_action_mcycle <= cycles then
          next_action_mcycle = next_action_mcycle
            + ((((cycles-periodic_action_start)//periodic_action_period)+1) * periodic_action_period)
      end
      return next_action_mcycle
    end
    return math.maxinteger
end

local function run_machine(machine, max_mcycle, callback)
    callback = callback or nothing
    local cycles = machine:read_mcycle()
    local next_action_mcycle = get_next_action_mcycle(cycles)
    while math.ult(cycles, max_mcycle) do
        machine:run(math.min(next_action_mcycle, max_mcycle))
        cycles = machine:read_mcycle()
        if periodic_action and cycles == next_action_mcycle then
            next_action_mcycle = next_action_mcycle + periodic_action_period
            callback(machine)
        end
        if machine:read_iflags_H() or machine:read_iflags_Y() then break end
    end
    return machine:read_mcycle()
end

local function connect()
    local server = cartesi.grpc.stub(server_address)
    local version = assert(server.get_version(),
        "could not connect to cartesi machine GRPC server at " .. server_address)
    local shutdown = function() server:shutdown() end
    local mt = { __gc = function() pcall(shutdown) end}
    setmetatable(cleanup, mt)
    return server, version
end

local function build_machine(test_name)
    local config = {
        processor = {
            -- Request automatic default values for versioning CSRs
            mimpid = -1,
            marchid = -1,
            mvendorid = -1
        },
        rom = {
            image_filename = test_path .. "/bootstrap.bin"
        },
        ram = {
            length = 32 << 20,
            image_filename = test_path .. "/" .. test_name
        },
        htif = {
            console_getchar = false,
            yield_progress = true,
            yield_rollup = true
        },
    }
    if server_address then
      if not server then server = connect() end
      return assert(server.machine(config))
    end
    return assert(cartesi.machine(config))
end

local function print_machine(test_name, expected_cycles)
    print(
        string.format(
            "./cartesi-machine.lua --no-root-image --ram-length=32Mi --rom-image-filename='%s' --ram-image-filename='%s' --no-rom-bootargs --max-mcycle=%d",
            test_path .. "/bootstrap.bin",
            test_path .. "/" .. test_name,
            2*expected_cycles
        )
    )
end

local function add_error(errors, ram_image, msg, ...)
    local e = string.format(msg, ...)
    if not errors[ram_image] then errors[ram_image] = {} end
    local ram_image_errors = errors[ram_image]
    ram_image_errors[#ram_image_errors + 1] = e
end

local function check_test_result(machine, ctx, errors)
    if machine:read_iflags_Y() then
        local expected_yield_payload = ctx.expected_yield_payloads[ctx.yield_payload_index] or 0
        ctx.yield_payload_index = ctx.yield_payload_index + 1
        if machine:read_htif_tohost_data() ~= expected_yield_payload then
            add_error(errors, ctx.ram_image, "returned yield payload %d, expected %d", machine:read_htif_tohost_data(), expected_yield_payload)
            ctx.failed = true
        end
    else
        if #ctx.expected_yield_payloads ~= (ctx.yield_payload_index - 1) then
            add_error(errors, ctx.ram_image, "yielded %d times, expected %d", ctx.yield_payload_index-1, #ctx.expected_yield_payloads)
            ctx.failed = true
        end
        if machine:read_htif_tohost_data() >> 1 ~= ctx.expected_halt_payload then
            add_error(errors, ctx.ram_image, "returned halt payload %d, expected %d",  machine:read_htif_tohost_data() >> 1, ctx.expected_halt_payload)
            ctx.failed = true
        end
        if ctx.cycles ~= ctx.expected_cycles then
            add_error(errors, ctx.ram_image, "terminated with mcycle = %d, expected %d", ctx.cycles, ctx.expected_cycles)
            ctx.failed = true
        end
    end
end

local function run(tests)
    local errors, error_count = {}, 0
    for _, test in ipairs(tests) do
        local ctx = {
            ram_image = test[1],
            expected_cycles = test[2],
            expected_halt_payload = test[3] or 0,
            expected_yield_payloads = test[4] or {},
            yield_payload_index = 1,
            failed = false,
            cycles = 0
        }
        local machine = build_machine(ctx.ram_image)

        io.write(ctx.ram_image, ": ")
        repeat
            ctx.cycles = run_machine(machine, 2 * ctx.expected_cycles)
            check_test_result(machine, ctx, errors)
        until not machine:read_iflags_Y()

        if ctx.failed then
            print("failed")
            error_count = error_count + 1
        else
            print("passed")
        end
        machine:destroy()
    end
    if error_count > 0 then
        io.write(string.format("\nFAILED %d of %d tests:\n\n", error_count, #tests))
        for k, v in pairs(errors) do
          for _, e in ipairs(v) do
            io.write(string.format("\t%s: %s\n", k, e))
          end
        end
        os.exit(1, true)
    else
        io.write(string.format("\nPASSED all %d tests\n\n", #tests))
        os.exit(0, true)
    end
end

local function print_machine_hash(machine)
    machine:update_merkle_tree()
    print(machine:read_mcycle(), util.hexhash(machine:get_root_hash()))
end

local function hash(tests)
    for _, test in ipairs(tests) do
        local ram_image = test[1]
        local expected_cycles = test[2]
        local expected_payload = test[3] or 0
        local machine = build_machine(ram_image)
        local cycles
        io.write(ram_image, ":\n")
        print_machine_hash(machine)
        repeat
            cycles = run_machine(machine, 2 * expected_cycles, print_machine_hash)
        until not machine:read_iflags_Y()
        print_machine_hash(machine)
        if machine:read_htif_tohost_data() >> 1 ~= expected_payload or cycles ~= expected_cycles then
            os.exit(1, true)
        end
        machine:destroy()
    end
end

local function print_machines(tests)
    for _, test in ipairs(tests) do
        local ram_image = test[1]
        local expected_cycles = test[2]
        print_machine(ram_image, expected_cycles)
    end
end

local function print_machine_json_log(machine, log_type, out)
    local init_cycles = machine:read_mcycle()
    local log = machine:step(log_type)
    local final_cycles = machine:read_mcycle()
    util.dump_json_log(log, init_cycles, final_cycles, out, 3)
    if not machine:read_iflags_H() then out:write(',\n')
    else out:write('\n') end
end

local function step(tests)
    local out = io.stdout
    local indentout = util.indentout
    local log_type = {} -- no proofs or annotations
    out:write("[\n")
    for i, test in ipairs(tests) do
        local ram_image = test[1]
        local expected_cycles = test[2]
        local expected_payload = test[3] or 0
        local machine = build_machine(ram_image)
        indentout(out, 1, "{\n")
        indentout(out, 2, '"test": "%s",\n', ram_image)
        if periodic_action then
            indentout(out, 2, '"period": %u,\n', periodic_action_period)
            indentout(out, 2, '"start": %u,\n', periodic_action_start)
        end
        indentout(out, 2, '"steps": [\n')
        local cycles
        print_machine_json_log(machine, log_type, out)
        repeat
            cycles = run_machine(machine, 2 * expected_cycles, function(machine)
                print_machine_json_log(machine, log_type, out)
            end)
        until not machine:read_iflags_Y()
        print_machine_json_log(machine, log_type, out)
        indentout(out, 2, "]\n")
        if tests[i+1] then indentout(out, 1, "},\n")
        else indentout(out, 1, "}\n") end
        if machine:read_htif_tohost_data() >> 1 ~= expected_payload or cycles ~= expected_cycles then
            os.exit(1, true)
        end
        machine:destroy()
    end
    io.stdout:write("]\n")
end

local function select(test_name, test_pattern)
    local i, j = test_name:find(test_pattern)
    if i == 1 and j == #test_name then return true end
    i, j = test_name:find(test_pattern, 1, true)
    return i == 1 and j == #test_name
end

local selected_tests = {}
for _, test in ipairs(tests) do
    if select(test[1], test_pattern) then
        selected_tests[#selected_tests+1] = test
    end
end

if #selected_tests < 1 then error("no test selected")
elseif command == "run" then run(selected_tests)
elseif command == "hash" then hash(selected_tests)
elseif command == "step" then step(selected_tests)
elseif command == "list" then
    for _, test in ipairs(selected_tests) do
        print(test[1])
    end
elseif command == "machine" then print_machines(selected_tests)
else error("command not found") end
