// Copyright 2019 Cartesi Pte. Ltd.
//
// This file is part of the machine-emulator. The machine-emulator is free
// software: you can redistribute it and/or modify it under the terms of the GNU
// Lesser General Public License as published by the Free Software Foundation,
// either version 3 of the License, or (at your option) any later version.
//
// The machine-emulator is distributed in the hope that it will be useful, but
// WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
// FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License
// for more details.
//
// You should have received a copy of the GNU Lesser General Public License
// along with the machine-emulator. If not, see http://www.gnu.org/licenses/.
//

#ifndef UARCH__INTERPRET_H
#define UARCH__INTERPRET_H

#include "state-access.h"
#include "uarch-state-access.h"

namespace cartesi {

enum class uarch_interpreter_status : int { success, halt };

// Run the microarchitecture interpreter until cycle hits a target or the micro machine halts
template <typename MACRO_STATE_ACCESS>
uarch_interpreter_status uarch_interpret(uarch_state_access<MACRO_STATE_ACCESS> &a, uint64_t uarch_cycle_end);

extern template uarch_interpreter_status uarch_interpret(uarch_state_access<state_access> &ua, uint64_t cycle_end);

} // namespace cartesi

#endif